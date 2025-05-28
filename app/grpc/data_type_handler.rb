# frozen_string_literal: true

class DataTypeHandler < Tucana::Sagittarius::DataTypeService::Service
  include GrpcHandler
  include Code0::ZeroTrack::Loggable

  def update(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])

    response = Runtimes::DataTypes::UpdateService.new(current_runtime, request.data_types).execute

    logger.info(message: 'Data types updated', runtime_id: current_runtime.id, response: response)

    Tucana::Sagittarius::DataTypeUpdateResponse.new(success: response.success?)
  end
end
