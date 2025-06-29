# frozen_string_literal: true

module GrpcStreamHandler
  include Code0::ZeroTrack::Loggable
  extend ActiveSupport::Concern

  class_methods do
    def grpc_stream(method)
      define_method(method) do |_, call|
        current_runtime_id = Code0::ZeroTrack::Context.current[:runtime][:id]

        create_enumerator(self.class, method, current_runtime_id, call.instance_variable_get(:@wrapped))
      end

      define_singleton_method("send_#{method}") do |grpc_object, runtime_id|
        GrpcStreamHandler.logger.info(message: 'Sending data', runtime_id: runtime_id, method: method,
                                      grpc_object: grpc_object)

        encoded_data = send('encoders')[method].call(grpc_object)
        encoded_data64 = Base64.encode64(encoded_data)

        GrpcStreamHandler.logger.info(message: 'Encoded data', runtime_id: runtime_id, method: method,
                                      encoded_data: encoded_data64)

        ActiveRecord::Base.connection.raw_connection
                          .exec("NOTIFY grpc_streams, '#{self},#{method},#{runtime_id},#{encoded_data64}'")
      end
      define_singleton_method("end_#{method}") do |runtime_id|
        ActiveRecord::Base.connection.raw_connection
                          .exec("NOTIFY grpc_streams, '#{self},#{method},#{runtime_id},end'")
      end
    end
  end

  def self.stop_listen!
    logger.info(message: 'Stopping listener')
    GrpcStreamHandler.exiting = true
  end

  def self.listen!
    ActiveRecord::Base.with_connection do |ar_conn|
      conn = ar_conn.raw_connection
      conn.exec('LISTEN grpc_streams')

      logger.info(message: 'Listening for notifications on grpc_streams channel')
      loop do
        break if GrpcStreamHandler.exiting

        conn.wait_for_notify(1) do |_, _, payload|
          logger.info(message: 'Received notification', payload: payload)
          class_name, method_name, runtime_id, encoded_data64 = payload.split(',')

          clazz = class_name.constantize
          method_name = method_name.to_sym

          if encoded_data64 == 'end'
            decoded_data = :end
          else
            data = Base64.decode64(encoded_data64)
            decoded_data = clazz.send('decoders')[method_name].call(data)
          end

          queues = GrpcStreamHandler.yielders.dig(clazz, method_name, runtime_id.to_i)
          queues&.each do |queue|
            queue << decoded_data
          rescue StandardError => e
            logger.error(message: 'Error while yielding data', error: e.message)
          end
        end
      end
      conn.exec('UNLISTEN grpc_streams')
      logger.info(message: 'Stopped listening for notifications on grpc_streams channel')
    end
  end

  def create_enumerator(clazz, method, runtime_id, _call)
    logger.debug(message: 'Creating enumerator', runtime_id: runtime_id, clazz: clazz, method: method)

    queue = Queue.new

    enumerator = Enumerator.new do |y|
      loop do
        item = queue.pop(timeout: 1)
        next if item.nil?
        break if item == :end

        begin
          y << item
        rescue GRPC::Core::CallError
          logger.info(message: 'Stream was closed from client side (probably)')
          clazz.try("#{method}_died", runtime_id)

          raise
        end
      end
      logger.info(message: 'Stream was closed from server side')
      clazz.try("#{method}_died", runtime_id)
    end

    GrpcStreamHandler.yielders[clazz] ||= {}
    GrpcStreamHandler.yielders[clazz][method] ||= {}
    GrpcStreamHandler.yielders[clazz][method][runtime_id] ||= []

    GrpcStreamHandler.yielders[clazz][method][runtime_id] << queue

    clazz.try("#{method}_started", runtime_id)

    enumerator
  end

  mattr_accessor :yielders, :exiting
  GrpcStreamHandler.yielders = {}
  GrpcStreamHandler.exiting = false
end
