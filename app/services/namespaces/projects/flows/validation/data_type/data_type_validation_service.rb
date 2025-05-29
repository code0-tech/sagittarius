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
              logger.debug("Validating data type: #{data_type.name} for flow: #{flow.id}")

              transactional do |t|
                if data_type.invalid?
                  logger.debug(message: "Data type validation failed",
                               flow: flow.id,
                               data_type: data_type.id,
                               errors: data_type.errors.full_messages)
                  t.rollback_and_return!(
                    ServiceResponse.error(
                      message: 'Data type is invalid',
                      payload: data_type.errors,
                    )
                  )
                end

                primary_runtime = flow.project.primary_runtime

                if primary_runtime != data_type.runtime
                  logger.debug(message: "Data type runtime mismatch",
                               primary_runtime: primary_runtime.id,
                               given_runtime: data_type.runtime.id,
                               flow: flow.id,
                               data_type: data_type.id
                  )
                  t.rollback_and_return!(
                    ServiceResponse.error(
                      message: 'Data type runtime does not match the primary runtime of the project',
                      payload: :runtime_mismatch
                    )
                  )
                end

                data_type.parent_type&.tap do |parent_type|
                  logger.debug("Validating parent type: #{parent_type.id} for data type: #{data_type.id}")
                  DataTypeValidationService.new(
                    current_authentication,
                    flow,
                    parent_type
                  ).execute
                end

                data_type.rules.each do |rule|
                  logger.debug("Validating data type rule: #{rule.id} for data type: #{data_type.id}")
                  ::DataTypeRuleValidationService.new(
                    current_authentication,
                    flow,
                    data_type,
                    rule
                  ).execute
                end

                logger.debug(message: "Data type is valid", flow: flow.id, data_type: data_type.id)
              end
            end
          end
        end
      end
    end
  end
end
