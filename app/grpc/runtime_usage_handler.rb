# frozen_string_literal: true

class RuntimeUsageHandler < Tucana::Sagittarius::RuntimeUsageService::Service
  include GrpcHandler
  include Code0::ZeroTrack::Loggable

  def update(request, _call)
    current_runtime = Runtime.find(Code0::ZeroTrack::Context.current[:runtime][:id])

    request.runtime_usage.each do |usage_info|
      flow = Flow.find_by(id: usage_info.flow_id)

      if flow.nil? || flow.project.primary_runtime != current_runtime
        logger.error(
          message: 'Flow not found or does not belong to current runtime',
          runtime_id: current_runtime.id,
          flow_id: usage_info.flow_id
        )
        return Tucana::Sagittarius::RuntimeUsageResponse.new(success: false)
      end
      flow.last_execution_duration = usage_info.duration.to_i
      flow.save!
    end

    Tucana::Sagittarius::RuntimeUsageeResponse.new(success: true)
  end
end
