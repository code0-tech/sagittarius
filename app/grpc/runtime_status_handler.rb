# frozen_string_literal: true

class RuntimeStatusHandler < Tucana::Sagittarius::RuntimeStatusService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler

  # TODO: Implement in #1018
  def update_disabled(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])
    status_info = request.status
    return Tucana::Sagittarius::RuntimeStatusUpdateResponse.new(success: false) if status_info.nil?

    response = Runtimes::Grpc::RuntimeStatusUpdateService.new(
      runtime: current_runtime,
      status_info: status_info
    ).execute

    logger.debug("RuntimeFunctionHandler#update response: #{response.inspect}")

    Tucana::Sagittarius::RuntimeStatusUpdateResponse.new(success: response.success?)
  end
end
