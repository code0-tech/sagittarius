# frozen_string_literal: true

module EE
  module Namespaces
    module Projects
      module Flows
        # Notifies about usage limits once per namespace the batch recorded usage for.
        module RecordRuntimeUsageBatchService
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
  end
end
