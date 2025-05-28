# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module NodeFunction
          class NodeFunctionValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :node_function

            def initialize(current_authentication, flow, node_function)
              @current_authentication = current_authentication
              @flow = flow
              @node_function = node_function
            end

            def execute
              logger.debug("Validating node function: #{node_function.id} for flow: #{flow.id}")

              transactional do |t|
                if node_function.invalid?
                  logger.debug(message: "Node function validation failed",
                               errors: node_function.errors.full_messages)
                  t.rollback_and_return!(
                    ServiceResponse.error(
                      message: 'Node function is invalid',
                      payload: node_function.errors
                    )
                  )
                end

                node_function.next_node&.tap do |next_node|
                  logger.debug("Validating next node function: #{next_node.id} for flow: #{flow.id}")
                  NodeFunctionValidationService.new(
                    current_authentication,
                    flow,
                    next_node
                  ).execute
                end

                node_function.runtime_function.tap do |runtime_function|
                  logger.debug("Validating runtime function: #{runtime_function.id} for node function: #{node_function.id}")
                  if runtime_function.runtime != flow.project.primary_runtime
                    logger.debug(message: "Runtime function runtime mismatch",
                                 primary_runtime: flow.project.primary_runtime.id,
                                 given_runtime: runtime_function.runtime.id,
                                 flow: flow.id,
                                 node_function: node_function.id)

                    t.rollback_and_return!(
                      ServiceResponse.error(
                        message: 'Function runtime definition does not match the primary runtime of the project',
                        payload: :runtime_mismatch
                      )
                    )
                  end
                end

                node_function.node_parameters.each do |parameter|
                  logger.debug("Validating node parameter: #{parameter.id} for function: #{node_function.id}")

                  if parameter.runtime_parameter != node_function.runtime_function
                    logger.debug(message: "Node parameter does not match its function",
                                 node_function: node_function.id,
                                 runtime_parameter: parameter.runtime_parameter.id,
                                 flow: flow.id)
                    t.rollback_and_return!(
                      ServiceResponse.error(
                        message: 'Node parameter does not match its function',
                        payload: :parameter_mismatch
                      )
                    )
                  end

                  ::NodeFunctionParameterValidationService.new(
                    current_authentication,
                    flow,
                    node_function,
                    parameter
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
