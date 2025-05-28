# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module DataType
          class GenericDataTypeIdentifierValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :data_type_identifier

            def initialize(current_authentication, flow, data_type_identifier)
              @current_authentication = current_authentication
              @flow = flow
              @data_type_identifier = data_type_identifier
            end

            def execute
              logger.debug("Validating flow_type: #{data_type_identifier.inspect} for flow: #{flow.id}")

              transactional do |t|
                if data_type_identifier.invalid?
                  logger.debug(message: "Data type identifier validation failed",
                               flow: flow.id,
                               data_type_identifier: data_type_identifier.id,
                               errors: data_type_identifier.errors.full_messages)
                  t.rollback_and_return!(
                    ServiceResponse.error(
                      message: 'Data type identifier is invalid',
                      payload: data_type_identifier.errors
                    )
                  )
                end
                if data_type_identifier.runtime != flow.project.primary_runtime
                  logger.debug(message: "Data type identifier runtime mismatch",
                               primary_runtime: flow.project.primary_runtime.id,
                               given_runtime: data_type_identifier.runtime.id,
                               flow: flow.id,
                               data_type_identifier: data_type_identifier.id)
                  t.rollback_and_return!(
                    ServiceResponse.error(
                      message: 'Data type identifier runtime does not match the primary runtime of the project',
                      payload: :runtime_mismatch
                    )
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
