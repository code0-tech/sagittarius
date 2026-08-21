# frozen_string_literal: true

module Velorum
  # Rolls a successful generation call up into its project's daily AI usage row. Runs after
  # GenerateFlowService's own success path so a failure here never blocks returning the
  # generated flow to the caller: any error is rescued and logged instead of propagating.
  # namespace_id is stored denormalized on the same row so namespace/application-level usage
  # can be read straight off this one table.
  class RecordGenerationUsageService
    include Code0::ZeroTrack::Loggable

    attr_reader :project, :usage, :flow

    def initialize(project:, usage:, flow: nil)
      @project = project
      @usage = usage
      @flow = flow
    end

    def execute
      AiUsageDailyAggregate.record_generation!(
        project_id: project.id, namespace_id: project.namespace_id,
        flow_id: flow&.id || AiUsageDailyAggregate::NO_FLOW,
        usage: usage, unique_by: %i[project_id flow_id date]
      )

      ServiceResponse.success(message: 'Generation usage recorded')
    rescue StandardError => e
      logger.error(message: 'Failed to record generation usage', project_id: project.id, error: e.message)

      ServiceResponse.error(message: 'Failed to record generation usage',
                            error_code: :generation_usage_recording_failed)
    end
  end
end
