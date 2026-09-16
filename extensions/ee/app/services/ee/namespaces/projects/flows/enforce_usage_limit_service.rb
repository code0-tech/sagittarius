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
          extend ActiveSupport::Concern

          override :execute
          def execute
            return ServiceResponse.success(message: 'Usage within limit') unless limit_exceeded?

            disable_flows!

            ServiceResponse.success(message: 'Usage limit exceeded, flows disabled')
          end

          class_methods do
            include Sagittarius::Override

            # Own module so Cloud can override it away (see
            # CLOUD::Namespaces::Projects::Flows::EnforceUsageLimitService::ClassOverrides).
            override :concurrency_scope_key
            def concurrency_scope_key(_flow)
              'installation'
            end
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

          # EE: every enabled flow, installation-wide.
          def scope_flows
            Flow.enabled
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
