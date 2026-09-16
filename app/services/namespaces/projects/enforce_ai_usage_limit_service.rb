# frozen_string_literal: true

module Namespaces
  module Projects
    # No-op in core: AI usage limits are an EE/Cloud licensing concern (see
    # EE::Namespaces::Projects::EnforceAiUsageLimitService and its Cloud override). Checked
    # synchronously per generation request (see Mutations::Ai::GenerateFlow) rather than via a
    # background job, since it isn't a hot path like runtime executions.
    class EnforceAiUsageLimitService
      attr_reader :project

      def initialize(project)
        @project = project
      end

      def execute
        ServiceResponse.success(message: 'No AI usage limit enforcement configured')
      end
    end
  end
end

Namespaces::Projects::EnforceAiUsageLimitService.prepend_extensions
