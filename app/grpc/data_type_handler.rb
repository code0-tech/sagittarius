# frozen_string_literal: true

class DataTypeHandler < Tucana::Sagittarius::DataTypeService::Service
  include GrpcHandler

  def update(request, _call)
    current_runtime = Runtime.find(Sagittarius::Context.current[:runtime][:id])

    response = Namespaces::DataTypes::UpdateService.new(current_runtime, request.data_types).execute

    Tucana::Sagittarius::DataTypeUpdateResponse.new(success: response.success?)
  end
end
