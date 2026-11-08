# frozen_string_literal: true

module Namespaces
  module Usage
    # Mails the administrators when a metered resource is about to run out, and again when it
    # has. Defined in the EE extension because usage limits are a licensing concern - core has
    # no limits to notify about and therefore no reason to know this service exists.
    #
    # The implementation lives in EE::Namespaces::Usage::NotifyLimitsService, with
    # CLOUD::Namespaces::Usage::NotifyLimitsService narrowing it from EE's installation-wide
    # license to a single namespace's. This class is only their override target, which is what
    # lets the two be tested apart (see the specs).
    #
    # Called right after usage is recorded (see EE::Velorum::RecordGenerationUsageService and
    # EE::Namespaces::Projects::Flows::RecordRuntimeUsageBatchService), i.e. on every generation
    # and every reported batch of executions. Sending at most one mail per resource, threshold
    # and billing cycle is the implementation's job, not the caller's - it claims
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
