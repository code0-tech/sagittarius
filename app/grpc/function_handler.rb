# frozen_string_literal: true

class FunctionHandler < Tucana::Sagittarius::FunctionDefinitionService::Service
  include GrpcHandler
  include Code0::ZeroTrack::Loggable

  def update(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])

    response = Runtimes::Grpc::FunctionDefinitions::UpdateService.new(
      current_runtime,
      request.functions
    ).execute

    logger.debug("FunctionHandler#update response: #{response.inspect}")

    Tucana::Sagittarius::FunctionDefinitionUpdateResponse.new(success: response.success?)
  end
end
