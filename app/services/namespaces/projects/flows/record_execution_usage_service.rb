# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      # Rolls a persisted execution result up into its flow's daily usage row. Runs after
      # PersistExecutionResultService so a failure here never blocks persisting the
      # execution result itself: any error is rescued and logged instead of propagating.
      # project_id/namespace_id are stored denormalized on the same row so project/
      # namespace/application-level usage can be read straight off this one table.
      class RecordExecutionUsageService
        include Code0::ZeroTrack::Loggable

        attr_reader :execution_result

        def initialize(execution_result)
          @execution_result = execution_result
        end

        def execute
          date = execution_result.created_at.to_date
          duration_us = [execution_result.finished_at - execution_result.started_at, 0].max
          flow = execution_result.flow
          project = flow.project

          RuntimeUsageDailyAggregate.record_execution!(
            flow_id: flow.id, project_id: project.id, namespace_id: project.namespace_id,
            date: date, execution_time_us: duration_us, unique_by: %i[flow_id date]
          )

          ServiceResponse.success(message: 'Execution usage recorded')
        rescue StandardError => e
          logger.error(message: 'Failed to record execution usage', execution_result_id: execution_result.id,
                       error: e.message)

          ServiceResponse.error(message: 'Failed to record execution usage',
                                error_code: :execution_usage_recording_failed)
        end
      end
    end
  end
end
