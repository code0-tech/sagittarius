# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module DataType
          class DataTypeIdentifierValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :node, :data_type_identifier

            def initialize(current_authentication, flow, node, data_type_identifier)
              @current_authentication = current_authentication
              @flow = flow
              @node = node
              @data_type_identifier = data_type_identifier
            end

            def execute
              errors = []
              logger.debug(message: 'Validating data_type_identifier', data_type_identifier: data_type_identifier.id,
                           flow_id: flow.id)

              if data_type_identifier.invalid?
                logger.debug(message: 'Data type identifier validation failed',
                             flow: flow.id,
                             data_type_identifier: data_type_identifier.id,
                             errors: data_type_identifier.errors.full_messages)
                errors << ValidationResult.error(
                  :data_type_identifier_model_invalid,
                  details: data_type_identifier.errors,
                  location: data_type_identifier
                )
              end
              if data_type_identifier.runtime != flow.project.primary_runtime
                logger.debug(message: 'Data type identifier runtime mismatch',
                             primary_runtime: flow.project.primary_runtime.id,
                             given_runtime: data_type_identifier.runtime.id,
                             flow: flow.id,
                             data_type_identifier: data_type_identifier.id)
                errors << ValidationResult.error(
                  :data_type_identifier_runtime_mismatch,
                  location: data_type_identifier
                )
              end

              if data_type_identifier.generic_key.present?
                unless node.runtime_function.generic_keys.include?(data_type_identifier.generic_key)
                  errors << ValidationResult.error(
                    :data_type_identifier_generic_key_not_found,
                    location: data_type_identifier
                  )
                end
              elsif data_type_identifier.generic_type.present?
                errors += ::NodeFunction::GenericTypeValidationService.new(
                  current_authentication,
                  flow,
                  data_type_identifier.generic_type
                ).execute
              elsif data_type_identifier.data_type.present?
                errors += DataTypeValidationService.new(
                  current_authentication,
                  flow,
                  data_type_identifier.data_type
                ).execute
              end

              errors
            end
          end
        end
      end
    end
  end
end
