# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module DataType
          class GenericMapperDataTypeIdentifierValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :parameter, :mapper, :data_type_identifier

            def initialize(current_authentication, flow, parameter, mapper, data_type_identifier)
              @current_authentication = current_authentication
              @flow = flow
              @parameter = parameter
              @mapper = mapper
              @data_type_identifier = data_type_identifier
            end

            def execute
              logger.debug("Validating generic_mapper: #{mapper.inspect}, source for flow: #{flow.id}")

              transactional do |t|
                ::GenericDataTypeIdentifierValidationService.new(
                  current_authentication,
                  flow,
                  data_type_identifier
                ).execute

                if data_type_identifier.generic_key.present?
                  unless parameter.function_value.runtime_function_definition.generic_keys.has?(data_type_identifier.generic_key)
                    t.rollback_and_return!(
                      ServiceResponse.error(
                        message: "Generic type #{parameter.generic_type.data_type.id} does not have a generic key for source #{source.generic_key}",
                        payload: :generic_key_not_found
                      )
                    )
                  end
                  return
                end
                if data_type_identifier.data_type.present?
                  DataTypeValidationService.new(
                    current_authentication,
                    flow,
                    data_type_identifier.data_type
                  ).execute
                  return
                end
                if data_type_identifier.generic_type.present?
                  ::NodeFunction::GenericTypeValidationService.new(
                    current_authentication,
                    flow,
                    source.generic_type
                  ).execute
                end
              end
            end
          end
        end
      end
    end
  end
end
