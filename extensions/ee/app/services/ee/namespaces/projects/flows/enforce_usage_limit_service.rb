# frozen_string_literal: true

module EE
  module Namespaces
    module Projects
      module Flows
        # EE licenses are installation-wide (not per-namespace), so both the usage pool and the
        # set of flows disabled when it's exceeded span the whole installation. Cloud narrows
        # both to a single namespace (see CLOUD::Namespaces::Projects::Flows::EnforceUsageLimitService).
        module EnforceUsageLimitService
          include Sagittarius::Override

          override :execute
          def execute
            return ServiceResponse.success(message: 'Usage within limit') unless limit_exceeded?

            disable_flows!

            ServiceResponse.success(message: 'Usage limit exceeded, flows disabled')
          end

          # Re-enables flows previously disabled for exceeding the usage limit, once usage is back
          # within the (possibly upgraded) limit. Triggered after a license change, since a new
          # license can raise the limit and/or shift the billing cycle so the pool is no longer
          # exceeded. Flows disabled for any other reason are left untouched.
          def reenable_flows
            return ServiceResponse.success(message: 'Usage still exceeds limit, flows stay disabled') if limit_exceeded?

            scope_disabled_flows.find_each do |scoped_flow|
              scoped_flow.reenable!
              ::FlowHandler.update_flow(scoped_flow)
            end

            ServiceResponse.success(message: 'Usage within limit, disabled flows re-enabled')
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
            return nil unless license.restricted?(:workflow_executions)

            license.restrictions[:workflow_executions]
          end

          def cycle_anchor
            license&.start_date || Date.current.beginning_of_month
          end

          def cycle_range
            Sagittarius::BillingCycle.range_for(cycle_anchor)
          end

          # EE: installation-wide usage pool.
          def scope_usage_relation
            RuntimeUsageDailyAggregate.all
          end

          # EE: all flows, installation-wide. Cloud narrows this to a single namespace; the enabled
          # / usage-limit-disabled scopes below are derived from it so both subclasses stay in sync.
          def flows_in_scope
            Flow.all
          end

          # Enabled flows eligible to be disabled when the pool is exceeded.
          def scope_flows
            flows_in_scope.enabled
          end

          # Flows disabled specifically for exceeding the usage limit, eligible to be re-enabled.
          def scope_disabled_flows
            flows_in_scope.disabled_reason_usage_limit_exceeded
          end

          def limit_exceeded?
            current_limit = limit
            return false if current_limit.nil?

            scope_usage_relation.where(date: cycle_range).sum(:execution_count) > current_limit
          end

          def disable_flows!
            reset_at = Sagittarius::BillingCycle.next_reset_date(cycle_anchor)

            scope_flows.find_each do |scoped_flow|
              scoped_flow.update!(disabled_reason: :usage_limit_exceeded, disabled_until: reset_at)
              ::FlowHandler.update_flow(scoped_flow)
            end
          end
        end
      end
    end
  end
end
