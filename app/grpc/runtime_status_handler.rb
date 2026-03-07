# frozen_string_literal: true

class RuntimeStatusHandler < Tucana::Sagittarius::RuntimeStatusService::Service
  include Code0::ZeroTrack::Loggable
  include GrpcHandler

  def update(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])
    status_info = case request.status
                  when :adapter_runtime_status
                    request.adapter_runtime_status
                  when :execution_runtime_status
                    request.execution_runtime_status
                  else
                    return Tucana::Sagittarius::RuntimeStatusUpdateResponse.new(success: false)
                  end

    response = Runtimes::Grpc::RuntimeStatusUpdateService.new(
      runtime: current_runtime,
      status_info: status_info
    ).execute

    logger.debug("RuntimeFunctionHandler#update response: #{response.inspect}")

    Tucana::Sagittarius::RuntimeStatusUpdateResponse.new(success: response.success?)
  end
end
