# frozen_string_literal: true

module CLOUD
  module Namespaces
    module Usage
      # Cloud licenses are per-namespace, so everything EE measures and notifies
      # installation-wide is narrowed to the namespace whose usage was just recorded (see
      # Namespaces::Usage::NotifyLimitsService).
      module NotifyLimitsService
        include Sagittarius::Override

        # The free-tier caps a namespace without a license runs on. Same numbers the enforcement
        # applies, read off those services so the mails can never state a limit that is not the
        # one actually enforced.
        FREE_LIMITS = {
          ai: CLOUD::Namespaces::Projects::EnforceAiUsageLimitService::FREE_AI_TOKEN_LIMIT,
          workflow: CLOUD::Namespaces::Projects::Flows::EnforceUsageLimitService::FREE_WORKFLOW_EXECUTION_LIMIT,
        }.freeze

        protected

        # Namespace#current_license memoizes, which matters for the same reason EE memoizes:
        # the mails read the limits back per recipient, and every read would be a query.
        override :license
        def license
          namespace.current_license
        end

        # Unlike EE, an unlicensed Cloud namespace is a perfectly normal free-tier namespace with
        # real limits to run into, so it is notified too.
        override :notify?
        def notify?
          true
        end

        override :limit_for
        def limit_for(usage_kind)
          return FREE_LIMITS.fetch(usage_kind) if license.nil?

          super
        end

        override :notification_namespace
        def notification_namespace
          namespace
        end

        override :cycle_anchor
        def cycle_anchor
          license&.start_date || namespace.created_at.to_date
        end

        override :ai_usage_relation
        def ai_usage_relation
          AiUsageDailyAggregate.where(namespace_id: namespace.id)
        end

        override :workflow_usage_relation
        def workflow_usage_relation
          RuntimeUsageDailyAggregate.where(namespace_id: namespace.id)
        end

        # Cloud: the namespace's own administrators, not the instance's.
        override :recipients
        def recipients
          namespace.administrator_users.notifiable
        end
      end
    end
  end
end
