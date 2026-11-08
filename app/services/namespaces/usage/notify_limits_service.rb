# frozen_string_literal: true

module Namespaces
  module Usage
    # No-op in core: usage limits - and therefore the mails about approaching or hitting one -
    # are an EE/Cloud licensing concern (see EE::Namespaces::Usage::NotifyLimitsService and its
    # Cloud override).
    #
    # Called right after usage is recorded (see Velorum::RecordGenerationUsageService and
    # Namespaces::Projects::Flows::RecordRuntimeUsageBatchService), i.e. on every generation and
    # every reported batch of executions. Sending at most one mail per resource, threshold and
    # billing cycle is the implementation's job, not the caller's - it claims
    # UsageLimitNotification rows to do it.
    #
    # `namespace` is the namespace whose usage was just recorded. EE ignores it (its licenses,
    # and so its usage pool, are installation-wide); Cloud scopes everything to it.
    class NotifyLimitsService
      attr_reader :namespace

      def initialize(namespace:)
        @namespace = namespace
      end

      def execute
        ServiceResponse.success(message: 'No usage limit notifications configured')
      end
    end
  end
end

Namespaces::Usage::NotifyLimitsService.prepend_extensions
