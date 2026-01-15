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
              errors = []
              logger.debug("Validating node function: #{node_function.id} for flow: #{flow.id}")

              if node_function.invalid?
                logger.debug(message: 'Node function validation failed',
                             errors: node_function.errors.full_messages)
                errors << ValidationResult.error(
                  :node_function_model_invalid,
                  details: node_function.errors,
                  location: node_function
                )
              end
              if node_function.function_definition.runtime_function_definition.runtime != flow.project.primary_runtime
                errors << ValidationResult.error(
                  :node_function_runtime_mismatch,
                  location: node_function
                )
              end

              node_function.function_definition.runtime_function_definition.tap do |runtime_function|
                logger
                  .debug("Validating runtime function: #{runtime_function.id} for node function: #{node_function.id}")
                if runtime_function.runtime != flow.project.primary_runtime
                  errors << ValidationResult.error(
                    :node_function_runtime_mismatch,
                    location: node_function
                  )
                end
              end

              node_function.node_parameters.each do |parameter|
                logger.debug("Validating node parameter: #{parameter.id} for function: #{node_function.id}")
                parameter_function_definition = parameter.parameter_definition.function_definition

                if parameter_function_definition != node_function.function_definition
                  logger.debug(message: 'Node parameter does not match its function',
                               node_function: node_function.id,
                               runtime_parameter: parameter.runtime_parameter.id,
                               flow: flow.id)
                  errors << ValidationResult.error(
                    :parameter_mismatch,
                    location: parameter
                  )
                end

                errors += NodeFunctionParameterValidationService.new(
                  current_authentication,
                  flow,
                  node_function,
                  parameter
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
