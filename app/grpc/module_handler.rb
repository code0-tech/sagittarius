# frozen_string_literal: true

class ModuleHandler < Tucana::Sagittarius::ModuleService::Service
  include GrpcHandler
  include Code0::ZeroTrack::Loggable

  def update(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])

    response = Runtimes::Grpc::Modules::UpdateService.new(current_runtime, request.modules).execute

    logger.debug("ModuleHandler#update response: #{response.inspect}")
    unless response.success?
      logger.error(message: 'Failed to update modules',
                   error: response.message,
                   details: response.payload)

      return Tucana::Sagittarius::ModuleUpdateResponse.new(
        success: false,
        error: Tucana::Shared::ServiceError.new(message: response.message)
      )
    end

    Tucana::Sagittarius::ModuleUpdateResponse.new(success: true)
  end
end
