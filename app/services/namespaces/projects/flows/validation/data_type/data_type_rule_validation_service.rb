# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module DataType
          class DataTypeRuleValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :data_type, :rule

            def initialize(current_authentication, flow, data_type, rule)
              @current_authentication = current_authentication
              @flow = flow
              @data_type = data_type
              @rule = rule
            end

            def execute
              logger.debug("Validating data type rule #{rule.id}")

              transactional do |t|
                if rule.invalid?
                  logger.debug(message: "Data type rule validation (model) failed",
                               flow: flow.id,
                               data_type: data_type.id,
                               rule: rule.id,
                               errors: rule.errors.full_messages)
                  t.rollback_and_return! ServiceResponse.error(
                    message: 'Data type rule is invalid',
                    payload: rule.errors
                  )
                end
              end
            end
          end
        end
      end
    end
  end
end
