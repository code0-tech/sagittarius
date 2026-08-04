# frozen_string_literal: true

class RuntimeStatusHandler < Tucana::Sagittarius::Rails::RuntimeStatusService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler

  def update(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])
    status_info = request.module_status || request.runtime_status
    return Tucana::Sagittarius::Rails::RuntimeStatusUpdateResponse.new(success: false) if status_info.nil?

    response = Runtimes::Grpc::RuntimeStatusUpdateService.new(
      runtime: current_runtime,
      status_info: status_info
    ).execute

    logger.debug("RuntimeFunctionHandler#update response: #{response.inspect}")

    response.to_grpc_response(Tucana::Sagittarius::Rails::RuntimeStatusUpdateResponse)
  end
end
