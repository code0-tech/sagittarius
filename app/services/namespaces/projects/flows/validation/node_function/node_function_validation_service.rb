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
                errors << ValidationResult.error(:node_function_model_invalid, node_function.errors)
              end
              if node_function.runtime_function.runtime != flow.project.primary_runtime
                errors << ValidationResult.error(:node_function_runtime_mismatch)
              end

              node_function.runtime_function.tap do |runtime_function|
                logger
                  .debug("Validating runtime function: #{runtime_function.id} for node function: #{node_function.id}")
                if runtime_function.runtime != flow.project.primary_runtime
                  errors << ValidationResult.error(:node_function_runtime_mismatch)
                end
              end

              node_function.node_parameters.each do |parameter|
                logger.debug("Validating node parameter: #{parameter.id} for function: #{node_function.id}")

                if parameter.runtime_parameter.runtime_function_definition != node_function.runtime_function
                  logger.debug(message: 'Node parameter does not match its function',
                               node_function: node_function.id,
                               runtime_parameter: parameter.runtime_parameter.id,
                               flow: flow.id)
                  errors << ValidationResult.error(:parameter_mismatch)
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
