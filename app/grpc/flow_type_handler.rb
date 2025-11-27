# frozen_string_literal: true

class FlowTypeHandler < Tucana::Sagittarius::FlowTypeService::Service
  include GrpcHandler

  def update(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])

    response = Runtimes::Grpc::FlowTypes::UpdateService.new(current_runtime, request.flow_types).execute

    Tucana::Sagittarius::FlowTypeUpdateResponse.new(success: response.success?)
  end
end
