# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module NodeFunction
          class NodeFunctionParameterValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :node_function, :parameter

            def initialize(current_authentication, flow, node_function, parameter)
              @current_authentication = current_authentication
              @flow = flow
              @node_function = node_function
              @parameter = parameter
            end

            def execute
              logger.debug("Validating node parameter: #{parameter.id} for flow: #{flow.id}")

              transactional do |t|
                if parameter.invalid?
                  logger.debug(message: "Node parameter validation failed",
                               errors: parameter.errors.full_messages)
                  t.rollback_and_return!(
                    ServiceResponse.error(
                      message: 'Node function is invalid',
                      payload: parameter.errors
                    )
                  )
                end
                if parameter.literal_value.present?
                  return
                end
                if parameter.reference_value.present?
                  ReferenceValueValidationService.new(
                    current_authentication,
                    flow,
                    parameter.reference_value
                  ).execute
                  return
                end
                if parameter.function_value.present?
                  logger.debug("Validating function value: #{parameter.function_value.id} for node parameter: #{parameter.id}")
                  NodeFunctionValidationService.new(
                    current_authentication,
                    flow,
                    parameter.function_value
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
