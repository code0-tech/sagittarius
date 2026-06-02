# frozen_string_literal: true

class RuntimeUsageHandler < Tucana::Sagittarius::RuntimeUsageService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler

  def update(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])
    response = Runtimes::Grpc::RuntimeUsageUpdateService.new(
      runtime: current_runtime,
      usages: request.runtime_usage
    ).execute

    logger.debug("RuntimeUsageHandler#update response: #{response.inspect}")

    Tucana::Sagittarius::RuntimeUsageResponse.new(success: response.success?)
  end
end
