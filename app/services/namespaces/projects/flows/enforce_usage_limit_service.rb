# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      # No-op in core: runtime usage limits are an EE/Cloud licensing concern (see
      # EE::Namespaces::Projects::Flows::EnforceUsageLimitService and its Cloud override).
      #
      # `flow` drives enforcement during usage recording; `namespace` lets Cloud re-enable a
      # namespace's disabled flows after a license upgrade, where no single flow is in context.
      class EnforceUsageLimitService
        attr_reader :flow

        def initialize(flow = nil, namespace: nil)
          @flow = flow
          @namespace = namespace
        end

        def execute
          ServiceResponse.success(message: 'No usage limit enforcement configured')
        end
      end
    end
  end
end

Namespaces::Projects::Flows::EnforceUsageLimitService.prepend_extensions
