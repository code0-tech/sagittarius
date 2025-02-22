# frozen_string_literal: true

class RuntimeFunctionHandler < Tucana::Sagittarius::RuntimeFunctionDefinitionService::Service
  include GrpcHandler

  def update(request, _call)
    current_runtime = Runtime.find(Sagittarius::Context.current[:runtime][:id])

    response = RuntimeFunctionDefinitions::UpdateService.new(current_runtime, request.runtime_functions).execute

    Tucana::Sagittarius::RuntimeFunctionDefinitionUpdateResponse.new(success: response.success?)
  end
end
