# frozen_string_literal: true

class RuntimeFunctionHandler < Tucana::Sagittarius::RuntimeFunctionDefinitionService::Service
  include GrpcHandler
  include Code0::ZeroTrack::Loggable

  def update(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])

    response = Runtimes::Grpc::RuntimeFunctionDefinitions::UpdateService.new(
      current_runtime,
      request.runtime_functions
    ).execute

    logger.debug("RuntimeFunctionHandler#update response: #{response.inspect}")

    Tucana::Sagittarius::RuntimeFunctionDefinitionUpdateResponse.new(success: response.success?)
  end
end
