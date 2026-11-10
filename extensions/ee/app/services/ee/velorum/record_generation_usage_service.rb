# frozen_string_literal: true

module EE
  module Velorum
    # Notifies about usage limits right after the recording, so the mail reflects the generation
    # that pushed usage over a threshold.
    module RecordGenerationUsageService
      include Sagittarius::Override
      extend ActiveSupport::Concern

      override :after_recording
      def after_recording(namespaces)
        namespaces.each do |namespace|
          ::Namespaces::Usage::NotifyLimitsService.new(namespace: namespace).execute
        end
      end
    end
  end
end
