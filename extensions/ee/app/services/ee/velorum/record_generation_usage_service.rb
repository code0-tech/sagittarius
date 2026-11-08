# frozen_string_literal: true

module EE
  module Velorum
    # Hooks the usage limit notifications onto the AI usage recording: right after the
    # recording, so the mail reflects the generation that pushed usage over a threshold. The
    # enforcement gate in Mutations::Ai::GenerateFlow runs before a generation and so can never
    # see that moment.
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
