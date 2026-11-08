# frozen_string_literal: true

module EE
  module Namespaces
    module Projects
      module Flows
        # Hooks the usage limit notifications onto the runtime usage recording. The batch hands
        # over every namespace it touched exactly once, so a batch spanning ten flows of one
        # namespace produces one notification run, not ten.
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
