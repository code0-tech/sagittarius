# frozen_string_literal: true

class ExecutionHandler < Tucana::Sagittarius::ExecutionService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler
  include GrpcStreamHandler

  grpc_stream :test

  def test(requests, call)
    current_runtime_id = Code0::ZeroTrack::Context.current[:runtime][:id]
    outbound_queue = nil

    enumerator = create_enumerator(
      self.class,
      :test,
      current_runtime_id,
      call.instance_variable_get(:@wrapped)
    ) do |queue|
      outbound_queue = queue
    end

    Thread.new do
      ActiveRecord::Base.connection_pool.with_connection do
        requests.each do |request|
          case request.data
          when :logon
            logger.info(message: 'Execution runtime sent logon', runtime_id: current_runtime_id)
          when :response
            handle_execution_result(request.response, current_runtime_id)
          end
        end
      end
    rescue StandardError => e
      logger.error(message: 'Error reading execution stream', error: e.message, runtime_id: current_runtime_id)
      outbound_queue << :end if outbound_queue
    ensure
      logger.info(message: 'Execution runtime request stream closed', runtime_id: current_runtime_id)
    end

    enumerator
  end

  def self.test_started(runtime_id)
    logger.info(message: 'Execution runtime connected', runtime_id: runtime_id)
  end

  def self.test_died(runtime_id)
    logger.info(message: 'Execution runtime disconnected', runtime_id: runtime_id)
  end

  def self.send_execution_request(runtime_id, test_execution_request)
    send_test(
      Tucana::Sagittarius::ExecutionLogonResponse.new(request: test_execution_request),
      runtime_id
    )
  end

  def self.encoders
    { test: ->(grpc_object) { Tucana::Sagittarius::ExecutionLogonResponse.encode(grpc_object) } }
  end

  def self.decoders
    { test: ->(string) { Tucana::Sagittarius::ExecutionLogonResponse.decode(string) } }
  end

  private

  def handle_execution_result(execution_result, runtime_id)
    logger.info(
      message: 'Received execution result',
      runtime_id: runtime_id,
      execution_identifier: execution_result.execution_identifier
    )

    response = Namespaces::Projects::Flows::PersistExecutionResultService.new(execution_result).execute
    return if response.success?

    logger.error(
      message: 'Failed to handle execution result',
      runtime_id: runtime_id,
      execution_identifier: execution_result.execution_identifier,
      error: response.message,
      details: response.payload
    )
  end
end
