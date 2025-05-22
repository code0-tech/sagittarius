# frozen_string_literal: true

module GrpcStreamHandler
  extend ActiveSupport::Concern
  include Code0::ZeroTrack::Loggable

  class_methods do

    def grpc_stream(method)

      define_method(method) do |_, _|
        # current_runtime_id = Code0::ZeroTrack::Context.current[:runtime][:id]
        current_runtime_id = 1

        create_enumerator(self.class, method, current_runtime_id)
      end

      define_method("send_#{method}") do |grpc_object, runtime_id|
        logger.info(message: 'Sending data', runtime_id: runtime_id, method: method)

        encoded_data = self.class.encoders[method].call(grpc_object)
        encoded_data64 = Base64.encode64(encoded_data)

        logger.info(message: 'Encoded data', runtime_id: runtime_id, method: method, encoded_data: encoded_data64)

        ActiveRecord::Base.connection.raw_connection.exec("NOTIFY grpc_streams, '#{self.class},#{method},#{runtime_id},#{encoded_data64}'")
      end
    end
  end

  def self.listen!
    conn = ActiveRecord::Base.connection.raw_connection
    conn.exec("LISTEN grpc_streams")

    loop do

      conn.wait_for_notify do |_, _, payload|
        class_name, method_name, runtime_id, encoded_data64 = payload.split(',')

        clazz = class_name.constantize
        method_name = method_name.to_sym

        queues = GrpcStreamHandler.yielders.dig(clazz, method_name, runtime_id.to_i)
        queues&.each do |queue|
          begin
            data = Base64.decode64(encoded_data64)
            decoded_data = clazz.decoders[method_name].call(data)

            queue << decoded_data
          rescue StandardError => e
            logger.error(message: 'Error while yielding data', error: e.message)
          end
        end
      end
    end
  end

  def create_enumerator(clazz, method, runtime_id)
    logger.debug(message: 'Creating enumerator', runtime_id: runtime_id, clazz: clazz, method: method)

    queue = Queue.new

    enumerator = Enumerator.new do |y|
      loop do
        item = queue.pop
        break if item == :end
        y << item
      end
    end

    GrpcStreamHandler.yielders[clazz] ||= {}
    GrpcStreamHandler.yielders[clazz][method] ||= {}
    GrpcStreamHandler.yielders[clazz][method][runtime_id] ||= []

    GrpcStreamHandler.yielders[clazz][method][runtime_id] << queue

    enumerator
  end

  mattr_accessor :yielders
  GrpcStreamHandler.yielders = {}

end
