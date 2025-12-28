# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module DataType
          class DataTypeValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :data_type

            def initialize(current_authentication, flow, data_type)
              @current_authentication = current_authentication
              @flow = flow
              @data_type = data_type
            end

            def execute
              errors = []

              logger.debug("Validating data type: #{data_type.id} for flow: #{flow.id}")

              if data_type.invalid?
                logger.debug(message: 'Data type validation failed',
                             flow: flow.id,
                             data_type: data_type.id,
                             errors: data_type.errors.full_messages)
                errors << ValidationResult.error(
                  :data_type_model_invalid,
                  details: data_type.errors,
                  location: data_type
                )
              end

              primary_runtime = flow.project.primary_runtime

              if primary_runtime != data_type.runtime
                logger.debug(message: 'Data type runtime mismatch',
                             primary_runtime: primary_runtime.id,
                             given_runtime: data_type.runtime.id,
                             flow: flow.id,
                             data_type: data_type.id)
                errors << ValidationResult.error(
                  :data_type_runtime_mismatch,
                  location: data_type
                )
              end

              data_type.parent_type&.tap do |parent_type|
                logger.debug("Validating parent type: #{parent_type.id} for data type: #{data_type.id}")
                errors += DataTypeIdentifierValidationService.new(
                  current_authentication,
                  flow,
                  nil,
                  parent_type
                ).execute
              end

              data_type.rules.each do |rule|
                logger.debug("Validating data type rule: #{rule.id} for data type: #{data_type.id}")
                errors += DataTypeRuleValidationService.new(
                  current_authentication,
                  flow,
                  data_type,
                  rule
                ).execute
              end

              logger.debug(message: 'Data type is valid', flow: flow.id, data_type: data_type.id)
              errors
            end
          end
        end
      end
    end
  end
end
