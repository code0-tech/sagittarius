# frozen_string_literal: true

class RuntimeUsageHandler < Tucana::Sagittarius::Rails::RuntimeUsageService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler

  # Called by the gateway with a batch of runtime usage Aquila has accumulated and flushed
  # for a commit group, rather than once per execution.
  def update(request, _call)
    current_runtime_id = Code0::ZeroTrack::Context.current[:runtime][:id]

    response = Namespaces::Projects::Flows::RecordRuntimeUsageBatchService.new(
      request.runtime_usage, current_runtime_id
    ).execute

    unless response.success?
      logger.error(
        message: 'Failed to record runtime usage batch',
        runtime_id: current_runtime_id,
        error: response.message
      )
    end

    response.to_grpc_response(Tucana::Sagittarius::Rails::RuntimeUsageResponse)
  end
end
