# frozen_string_literal: true

module CLOUD
  module Namespaces
    module Projects
      module Flows
        # Cloud licenses are per-namespace, so both the usage pool and the set of flows disabled
        # when it's exceeded are scoped to the flow's namespace instead of EE's installation-wide
        # defaults (see EE::Namespaces::Projects::Flows::EnforceUsageLimitService).
        module EnforceUsageLimitService
          include Sagittarius::Override

          FREE_WORKFLOW_EXECUTION_LIMIT = 50

          protected

          override :license
          def license
            ::License.current_for_namespace(namespace)
          end

          override :limit
          def limit
            return FREE_WORKFLOW_EXECUTION_LIMIT if license.nil?

            super
          end

          override :cycle_anchor
          def cycle_anchor
            license&.start_date || namespace.created_at.to_date
          end

          override :scope_usage_relation
          def scope_usage_relation
            RuntimeUsageDailyAggregate.where(namespace_id: namespace.id)
          end

          override :flows_in_scope
          def flows_in_scope
            Flow.where(project: NamespaceProject.where(namespace_id: namespace.id))
          end

          private

          # Enforcement derives the namespace from the flow being recorded; a license-triggered
          # re-enable passes the namespace explicitly, as there is no single flow in context.
          def namespace
            @namespace || flow.project.namespace
          end
        end
      end
    end
  end
end
