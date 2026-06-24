# frozen_string_literal: true

class ModuleHandler < Tucana::Sagittarius::ModuleService::Service
  include GrpcHandler
  include Code0::ZeroTrack::Loggable

  def update(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])

    response = Runtimes::Grpc::Modules::UpdateService.new(current_runtime, request.modules).execute

    logger.debug("ModuleHandler#update response: #{response.inspect}")
    unless response.success?
      logger.warn(message: 'Failed to update modules',
                  error: response.message,
                  details: response.payload)
    end

    response.to_grpc_response(Tucana::Sagittarius::ModuleUpdateResponse)
  end
end
