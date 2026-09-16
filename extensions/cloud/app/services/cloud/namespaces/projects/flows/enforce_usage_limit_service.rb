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

          # Not named ClassMethods: EE already defines one via `class_methods do`, and a second
          # same-named one here breaks Sagittarius::Override's ancestor-based lookup for EE's own
          # overrides (see CLOUD::FlowHandler for the same workaround).
          module ClassOverrides
            def concurrency_scope_key(flow)
              "namespace-#{flow.project.namespace_id}"
            end
          end

          def self.prepended(base)
            base.singleton_class.prepend(ClassOverrides)
          end

          protected

          override :license
          def license
            ::License.current_for_namespace(namespace)
          end

          override :limit
          def limit
            return 50 if license.nil?

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

          override :scope_flows
          def scope_flows
            Flow.enabled.where(project: NamespaceProject.where(namespace_id: namespace.id))
          end

          private

          def namespace
            flow.project.namespace
          end
        end
      end
    end
  end
end
