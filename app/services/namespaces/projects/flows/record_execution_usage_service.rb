# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      # Rolls a persisted execution result up into the flow/project/namespace/application
      # daily usage counters. Runs after PersistExecutionResultService so a failure here
      # never blocks persisting the execution result itself.
      class RecordExecutionUsageService
        attr_reader :execution_result

        def initialize(execution_result)
          @execution_result = execution_result
        end

        def execute
          date = execution_result.created_at.to_date
          duration_us = execution_result.finished_at - execution_result.started_at
          project = execution_result.flow.project

          FlowUsageDailyAggregate.record_execution!(
            flow_id: execution_result.flow_id, date: date, execution_time_us: duration_us
          )
          NamespaceProjectUsageDailyAggregate.record_execution!(
            project_id: project.id, date: date, execution_time_us: duration_us
          )
          NamespaceUsageDailyAggregate.record_execution!(
            namespace_id: project.namespace_id, date: date, execution_time_us: duration_us
          )
          ApplicationUsageDailyAggregate.record_execution!(date: date, execution_time_us: duration_us)

          ServiceResponse.success(message: 'Execution usage recorded')
        end
      end
    end
  end
end
