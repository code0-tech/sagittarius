# frozen_string_literal: true

class RuntimeUsageHandler < Tucana::Sagittarius::RuntimeUsageService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler

  def update(request, _call)
    response = Runtimes::Grpc::RuntimeUsageUpdateService.new(request).execute

    logger.debug("RuntimeUsageHandler#update response: #{response.inspect}")

    Tucana::Sagittarius::RuntimeUsageUpdateResponse.new(success: response.success?)
  end
end
