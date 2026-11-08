# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      # Records a batch of {flow_id, duration} usage entries Aquila reports periodically
      # (bucketed per commit group, not per execution) and enforces usage limits once per
      # unique flow touched. Entries for a flow_id that doesn't resolve to a flow assigned to
      # the reporting runtime are skipped and logged rather than failing the whole batch, since
      # record_execution! is an additive upsert and a retried batch would double-count any
      # entry that did succeed.
      class RecordRuntimeUsageBatchService
        include Code0::ZeroTrack::Loggable

        attr_reader :runtime_usages, :runtime_id

        def initialize(runtime_usages, runtime_id)
          @runtime_usages = runtime_usages
          @runtime_id = runtime_id
        end

        def execute
          touched_flows = {}

          runtime_usages.each do |usage|
            flow = flow_for(usage.flow_id)

            if flow.nil?
              logger.warn(message: 'Skipping runtime usage for unknown/foreign flow',
                          runtime_id: runtime_id, flow_id: usage.flow_id)
              next
            end

            RecordExecutionUsageService.new(flow: flow, duration: usage.duration).execute
            touched_flows[flow.id] ||= flow
          end

          touched_flows.each_value { |flow| EnforceUsageLimitService.new(flow).execute }

          # Once per namespace touched, not once per flow: what an extension does with a
          # recorded batch (EE mails about usage limits) is namespace- or installation-wide, so a
          # batch spanning ten flows of one namespace has exactly one situation to report.
          after_recording(namespaces_of(touched_flows.values))

          ServiceResponse.success(message: 'Runtime usage recorded')
        end

        protected

        # Extension hook, handed every namespace whose usage this batch recorded. Core has
        # nothing to do with it; EE notifies about usage limits from here (see
        # EE::Namespaces::Projects::Flows::RecordRuntimeUsageBatchService).
        def after_recording(_namespaces); end

        private

        def namespaces_of(flows)
          flows.map { |flow| flow.project.namespace }.uniq
        end

        def flow_for(flow_id)
          Flow
            .includes(:project)
            .joins(project: :runtime_assignments)
            .find_by(
              id: flow_id,
              namespace_project_runtime_assignments: { runtime_id: runtime_id }
            )
        end
      end
    end
  end
end

Namespaces::Projects::Flows::RecordRuntimeUsageBatchService.prepend_extensions
