# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      # Rolls a reported runtime usage duration up into its flow's daily usage row.
      # project_id/namespace_id are stored denormalized on the same row so project/
      # namespace/application-level usage can be read straight off this one table.
      class RecordExecutionUsageService
        include Code0::ZeroTrack::Loggable

        attr_reader :flow, :duration

        def initialize(flow:, duration:)
          @flow = flow
          @duration = duration
        end

        def execute
          project = flow.project

          RuntimeUsageDailyAggregate.record_execution!(
            flow_id: flow.id, project_id: project.id, namespace_id: project.namespace_id,
            date: Time.zone.today, execution_time_us: duration, unique_by: %i[flow_id date]
          )

          ServiceResponse.success(message: 'Execution usage recorded')
        rescue StandardError => e
          logger.error(message: 'Failed to record execution usage', flow_id: flow.id, error: e.message)

          ServiceResponse.error(message: 'Failed to record execution usage',
                                error_code: :execution_usage_recording_failed)
        end
      end
    end
  end
end
