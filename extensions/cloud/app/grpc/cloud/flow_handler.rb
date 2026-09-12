# frozen_string_literal: true

module CLOUD
  module FlowHandler
    # Not named ClassMethods: EE already has a FlowHandler::ClassMethods, and a second same-named
    # one here breaks Sagittarius::Override's ancestor-based lookup for EE's own overrides.
    module ClassOverrides
      # Cloud filters flow visibility per-namespace via disabled_reason, not via License.
      def no_active_license?
        false
      end
    end

    def self.prepended(base)
      base.singleton_class.prepend(ClassOverrides)
    end
  end
end
