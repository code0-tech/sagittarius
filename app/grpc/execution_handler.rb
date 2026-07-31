# frozen_string_literal: true

class ExecutionHandler < Tucana::Sagittarius::Rails::ExecutionService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler

  # Called by the gateway once per execution result Aquila sends over its stream.
  def update(request, _call)
    current_runtime_id = Code0::ZeroTrack::Context.current[:runtime][:id]
    execution_result = request.response

    logger.info(
      message: 'Received execution result',
      runtime_id: current_runtime_id,
      execution_identifier: execution_result.execution_identifier
    )

    response = Namespaces::Projects::Flows::PersistExecutionResultService.new(
      execution_result, current_runtime_id
    ).execute

    unless response.success?
      logger.error(
        message: 'Failed to handle execution result',
        runtime_id: current_runtime_id,
        execution_identifier: execution_result.execution_identifier,
        error: response.message,
        details: response.payload[:details]&.full_messages
      )
    end

    response.to_grpc_response(Tucana::Sagittarius::Rails::ExecutionResponse)
  end

  def self.send_execution_request(runtime_id, test_execution_request)
    gateway_client.push_execution(runtime_id, test_execution_request)
  end

  def self.gateway_client
    @gateway_client ||= Sagittarius::Gateway::Client.new
  end
end
