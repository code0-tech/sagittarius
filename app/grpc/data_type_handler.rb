# frozen_string_literal: true

class DataTypeHandler < Tucana::Sagittarius::DataTypeService::Service
  include GrpcHandler

  def update(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])

    response = Runtimes::DataTypes::UpdateService.new(current_runtime, request.data_types).execute

    Tucana::Sagittarius::DataTypeUpdateResponse.new(success: response.success?)
  end
end
