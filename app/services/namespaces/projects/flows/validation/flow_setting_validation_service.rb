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
            logger.debug("Validating setting: #{setting.inspect} for flow: #{flow.id}")

            transactional do |t|
              if setting.invalid?
                logger.debug("Invalid setting: #{setting.errors.full_messages.join(', ')}")
                t.rollback_and_return! ServiceResponse.error(
                  message: 'Invalid flow setting',
                  payload: setting.errors
                )
              end
            end

            # Maybe something in the future we will validate the setting object but currently its not typed
          end
        end
      end
    end
  end
end
