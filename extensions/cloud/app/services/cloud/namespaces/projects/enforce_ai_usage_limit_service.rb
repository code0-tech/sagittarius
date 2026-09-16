# frozen_string_literal: true

module CLOUD
  module Namespaces
    module Projects
      # Cloud licenses are per-namespace, so the token usage pool checked here is scoped to the
      # project's namespace instead of EE's installation-wide default (see
      # EE::Namespaces::Projects::EnforceAiUsageLimitService).
      module EnforceAiUsageLimitService
        include Sagittarius::Override

        protected

        override :license
        def license
          ::License.current_for_namespace(namespace)
        end

        override :limit
        def limit
          return 25_000 if license.nil?

          super
        end

        override :cycle_anchor
        def cycle_anchor
          license&.start_date || namespace.created_at.to_date
        end

        override :scope_usage_relation
        def scope_usage_relation
          AiUsageDailyAggregate.where(namespace_id: namespace.id)
        end

        private

        def namespace
          project.namespace
        end
      end
    end
  end
end
