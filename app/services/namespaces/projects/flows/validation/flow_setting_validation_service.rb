# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        class FlowSettingValidationService
          include Code0::ZeroTrack::Loggable
          include Sagittarius::Database::Transactional

          attr_reader :current_authentication, :flow, :setting

          def initialize(current_authentication, flow, setting)
            @current_authentication = current_authentication
            @flow = flow
            @setting = setting
          end

          def execute
            errors = []
            logger.debug("Validating setting: #{setting.inspect} for flow: #{flow.id}")

            if setting.invalid?
              logger.debug("Invalid setting: #{setting.errors.full_messages.join(', ')}")
              errors << ValidationResult.error(
                :flow_setting_model_invalid,
                details: setting.errors,
                location: setting
              )
            end
            errors
          end
        end
      end
    end
  end
end
