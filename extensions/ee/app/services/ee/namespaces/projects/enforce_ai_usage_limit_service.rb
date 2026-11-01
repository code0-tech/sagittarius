# frozen_string_literal: true

module EE
  module Namespaces
    module Projects
      # EE licenses are installation-wide (not per-namespace), so the token usage pool checked
      # here spans the whole installation. Cloud narrows it to a single namespace (see
      # CLOUD::Namespaces::Projects::EnforceAiUsageLimitService).
      module EnforceAiUsageLimitService
        include Sagittarius::Override
        extend ActiveSupport::Concern

        override :execute
        def execute
          return ServiceResponse.success(message: 'AI usage within limit') unless limit_exceeded?

          ServiceResponse.error(
            message: "AI usage limit exceeded for this billing cycle. Resets on #{reset_date}.",
            error_code: :ai_usage_limit_exceeded
          )
        end

        protected

        # Marked `protected`, not `private`, because Cloud needs to override several of these
        # (Sagittarius::Override's verification relies on Module#method_defined?, which ignores
        # private methods).

        def license
          License.current
        end

        # nil means unlimited.
        def limit
          return 0 if license.nil?
          return nil unless license.restricted?(:ai_tokens)

          license.restrictions[:ai_tokens]
        end

        def cycle_anchor
          license&.start_date || Date.current.beginning_of_month
        end

        def cycle_range
          Sagittarius::BillingCycle.range_for(cycle_anchor)
        end

        def reset_date
          Sagittarius::BillingCycle.next_reset_date(cycle_anchor)
        end

        # EE: installation-wide usage pool.
        def scope_usage_relation
          AiUsageDailyAggregate.all
        end

        # Checked before this request's generation happens, so it can't know this request's own
        # token cost - blocks once already-used usage has reached the limit, not once it's
        # exceeded it (compare to the runtime-execution feature's post-hoc `>`).
        def limit_exceeded?
          current_limit = limit
          return false if current_limit.nil?

          scope_usage_relation.where(date: cycle_range).sum(:total_usage) >= current_limit
        end
      end
    end
  end
end
