# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module DataType
          class GenericMapperDataTypeIdentifierValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :parameter, :mapper, :source

            def initialize(current_authentication, flow, parameter, mapper, source)
              @current_authentication = current_authentication
              @flow = flow
              @parameter = parameter
              @mapper = mapper
              @source = source
            end

            def execute
              logger.debug("Validating flow_type: #{data_type_identifier.inspect} for flow: #{flow.id}")

              transactional do |t|
                ::GenericDataTypeIdentifierValidationService.new(
                  current_authentication,
                  flow,
                  source
                ).execute

                if source.generic_key.present?
                  unless parameter.function_value.runtime_function_definition.generic_keys.has?(source.generic_key)
                    t.rollback_and_return!(
                      ServiceResponse.error(
                        message: "Generic type #{parameter.generic_type.data_type.id} does not have a generic key for source #{source.generic_key}",
                        payload: :generic_key_not_found
                      )
                    )
                  end
                  return
                end
                if source.data_type.present?
                  DataTypeValidationService.new(
                    current_authentication,
                    flow,
                    source.data_type
                  ).execute
                  return
                end
                if source.generic_type.present?
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
