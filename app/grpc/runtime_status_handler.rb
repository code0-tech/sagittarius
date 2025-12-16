# frozen_string_literal: true

class RuntimeStatusHandler < Tucana::Sagittarius::RuntimeStatusService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler

  def update(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])

    response = Runtimes::Grpc::RuntimeStatusUpdateService.new(
      current_runtime,
      request.status
    ).execute

    logger.debug("RuntimeFunctionHandler#update response: #{response.inspect}")

    Tucana::Sagittarius::RuntimeStatusUpdateResponse.new(success: response.success?)
  end
end
