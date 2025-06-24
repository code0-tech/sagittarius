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
              logger.debug(message: "Validating data_type_identifier", data_type_identifier: data_type_identifier.id, flow_id: flow.id)

              transactional do |t|
                if data_type_identifier.invalid?
                  logger.debug(message: 'Data type identifier validation failed',
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
                  logger.debug(message: 'Data type identifier runtime mismatch',
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

                if data_type_identifier.generic_key.present?
                  unless node.runtime_function.generic_keys.include?(data_type_identifier.generic_key)
                    t.rollback_and_return!(
                      ServiceResponse.error(
                        message: "Data type identifier #{data_type_identifier.id} " \
                                 'does not have a generic key which exists in the node function ' \
                                 "#{node.runtime_function.generic_keys}",
                        payload: :generic_key_not_found
                      )
                    )
                  end
                elsif data_type_identifier.generic_type.present?
                  ::NodeFunction::GenericTypeValidationService.new(
                    current_authentication,
                    flow,
                    data_type_identifier.generic_type
                  ).execute
                elsif data_type_identifier.data_type.present?
                  DataTypeValidationService.new(
                    current_authentication,
                    flow,
                    data_type_identifier.data_type
                  ).execute
                end

                nil
              end
            end
          end
        end
      end
    end
  end
end
