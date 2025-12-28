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
              errors = []
              logger.debug(message: 'Validating data type rule', rule_id: rule.id)

              transactional do |_t|
                if rule.invalid?
                  logger.debug(message: 'Data type rule validation (model) failed',
                               flow: flow.id,
                               data_type: data_type.id,
                               rule: rule.id,
                               errors: rule.errors.full_messages)
                  errors << ValidationResult.error(
                    :data_type_rule_model_invalid,
                    details: rule.errors,
                    location: rule
                  )
                end
              end
              errors
            end
          end
        end
      end
    end
  end
end
