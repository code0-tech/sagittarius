# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      # No-op in core: runtime usage limits are an EE/Cloud licensing concern (see
      # EE::Namespaces::Projects::Flows::EnforceUsageLimitService and its Cloud override).
      class EnforceUsageLimitService
        attr_reader :flow

        def initialize(flow)
          @flow = flow
        end

        def execute
          ServiceResponse.success(message: 'No usage limit enforcement configured')
        end

        # Groups per-execution-result checks (see EnforceRuntimeUsageLimitJob) that share the
        # same license scope, so a burst across many flows collapses into a single delayed check.
        # Core has no license scope, so each flow is its own group.
        def self.concurrency_scope_key(flow)
          "flow-#{flow.id}"
        end
      end
    end
  end
end

Namespaces::Projects::Flows::EnforceUsageLimitService.prepend_extensions
