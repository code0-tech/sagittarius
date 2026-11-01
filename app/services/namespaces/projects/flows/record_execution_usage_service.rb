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
            date: Time.zone.today, execution_time_us: duration, count: usage_weight, unique_by: %i[flow_id date]
          )

          ServiceResponse.success(message: 'Execution usage recorded')
        rescue StandardError => e
          logger.error(message: 'Failed to record execution usage', flow_id: flow.id, error: e.message)

          ServiceResponse.error(message: 'Failed to record execution usage',
                                error_code: :execution_usage_recording_failed)
        end

        private

        # How much this execution counts toward the usage limit. Executions up to the configured
        # threshold count as 1; each further whole threshold interval adds another (threshold 5s =>
        # <=5s counts as 1, a 6s execution as 2, an 11s execution as 3). A threshold of 0 (or less)
        # disables weighting, so every execution counts as 1.
        def usage_weight
          threshold_seconds = ApplicationSetting.current[:runtime_usage_duration_weight_threshold_seconds].to_i
          return 1 unless threshold_seconds.positive?

          threshold_us = threshold_seconds * 1_000_000
          [(duration + threshold_us - 1) / threshold_us, 1].max
        end
      end
    end
  end
end
