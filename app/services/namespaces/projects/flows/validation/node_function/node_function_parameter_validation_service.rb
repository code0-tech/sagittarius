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
              errors = []
              logger.debug("Validating node parameter: #{parameter.id} for flow: #{flow.id}")

              if parameter.invalid?
                logger.debug(message: 'Node parameter validation failed',
                             errors: parameter.errors.full_messages)
                errors << ValidationResult.error(:node_parameter_model_invalid, parameter.errors)
              end
              if parameter.runtime_parameter.runtime_function_definition.runtime != flow.project.primary_runtime
                errors << ValidationResult.error(:node_parameter_runtime_mismatch)
              end

              if parameter.literal_value.present?
                return errors # TODO: ig
              end

              if parameter.reference_value.present?
                errors += ReferenceValueValidationService.new(
                  current_authentication,
                  flow,
                  parameter.node_function,
                  parameter.reference_value
                ).execute
                return errors
              end
              if parameter.function_value.present?
                logger.debug("Validating function value:
                    #{parameter.function_value.id} for node parameter: #{parameter.id}")
                errors += NodeFunctionValidationService.new(
                  current_authentication,
                  flow,
                  parameter.function_value
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
