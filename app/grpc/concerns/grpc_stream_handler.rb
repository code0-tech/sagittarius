# frozen_string_literal: true

module GrpcStreamHandler
  include Code0::ZeroTrack::Loggable
  extend ActiveSupport::Concern

  StreamItem = Struct.new(:data, :otel_context, keyword_init: true)

  def self.tracer
    @tracer ||= ::OpenTelemetry.tracer_provider.tracer('sagittarius-grpc-stream')
  end

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
        encoded_data64 = Base64.encode64(encoded_data).delete("\n")

        GrpcStreamHandler.logger.info(message: 'Encoded data', runtime_id: runtime_id, method: method,
                                      encoded_data: encoded_data64)

        carrier = {}
        OpenTelemetry.propagation.inject(carrier)
        trace_context64 = Base64.encode64(carrier.to_json).delete("\n")

        notification_payload = "#{self},#{method},#{runtime_id},#{encoded_data64},#{trace_context64}"

        ActiveRecord::Base.connection.raw_connection
                          .exec("NOTIFY grpc_streams, '#{notification_payload}'")
      end
      define_singleton_method("end_#{method}") do |runtime_id|
        ActiveRecord::Base.connection.raw_connection
                          .exec("NOTIFY grpc_streams, '#{self},#{method},#{runtime_id},end,'")
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
          parts = payload.split(',')
          class_name = parts[0]
          method_name = parts[1]
          runtime_id = parts[2]
          encoded_data64 = parts[3]
          trace_context64 = parts[4]

          clazz = class_name.constantize
          method_name = method_name.to_sym

          otel_context = extract_otel_context(trace_context64)

          if encoded_data64 == 'end'
            decoded_data = :end
          else
            data = Base64.decode64(encoded_data64)
            decoded_data = clazz.send('decoders')[method_name].call(data)
          end

          queues = GrpcStreamHandler.yielders.dig(clazz, method_name, runtime_id.to_i)
          queues&.each do |queue|
            queue << StreamItem.new(data: decoded_data, otel_context: otel_context)
          rescue StandardError => e
            logger.error(message: 'Error while yielding data', error: e.message, backtrace: e.backtrace)
          end
        end
      end
      conn.exec('UNLISTEN grpc_streams')
      logger.info(message: 'Stopped listening for notifications on grpc_streams channel')
    end
  end

  def self.extract_otel_context(trace_context64)
    return nil if trace_context64.blank?

    carrier = JSON.parse(Base64.decode64(trace_context64))
    OpenTelemetry.propagation.extract(carrier)
  rescue StandardError
    nil
  end

  def create_enumerator(clazz, method, runtime_id, _call)
    logger.debug(message: 'Creating enumerator', runtime_id: runtime_id, clazz: clazz, method: method)

    queue = Queue.new

    queues = GrpcStreamHandler.yielders[clazz] ||= {}
    method_queues = queues[method] ||= {}
    runtime_queues = method_queues[runtime_id] ||= []

    runtime_queues.each { |existing_queue| existing_queue << StreamItem.new(data: :end, otel_context: nil) }
    runtime_queues.clear
    runtime_queues << queue

    yield queue if block_given?

    enumerator = Enumerator.new do |y|
      loop do
        item = queue.pop(timeout: 1)
        next if item.nil?
        break if item.data == :end

        otel_context = item.otel_context || OpenTelemetry::Context.current
        OpenTelemetry::Context.with_current(otel_context) do
          GrpcStreamHandler.tracer.in_span("#{clazz}/#{method} send") do |span|
            y << item.data
            ApplicationRecord.connection_pool.with_connection do
              Runtime.update(runtime_id, last_heartbeat: Time.zone.now)
            end
          rescue ActiveRecord::ActiveRecordError => e
            logger.warn(message: 'Failed to update runtime heartbeat', exception: e.message, backtrace: e.backtrace)
          rescue GRPC::Core::CallError => e
            logger.info(message: 'Stream was closed from client side (probably)')

            span.set_attribute('rpc.response.status_code', 'UNKNOWN')
            span.set_attribute('error.type', e.class.name)
            span.status = ::OpenTelemetry::Trace::Status.error(e.message)
            span.record_exception(e)

            raise
          end
        end
      end
    ensure
      logger.info(message: 'Stream was closed from server side')
      GrpcStreamHandler.yielders.dig(clazz, method, runtime_id)&.delete(queue)
      clazz.try("#{method}_died", runtime_id)
    end

    clazz.try("#{method}_started", runtime_id)

    enumerator
  end

  mattr_accessor :yielders, :exiting
  GrpcStreamHandler.yielders = {}
  GrpcStreamHandler.exiting = false
end
