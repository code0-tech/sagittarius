# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class ReassignDefinitionsToRuntimeService
        attr_reader :flow, :runtime

        def initialize(flow, runtime)
          @flow = flow
          @runtime = runtime
        end

        def execute
          reassign_flow_type
          reassign_node_function_definitions
        end

        private

        def reassign_flow_type
          flow.flow_type = runtime.flow_types.find_by(identifier: flow.flow_type.identifier)
          flow.save!
        end

        def reassign_node_function_definitions
          flow.node_functions.find_each do |node|
            reassign_node_function_definition(node)

            node.node_parameters.each do |parameter|
              reassign_node_parameter_definitions(parameter, node.function_definition)
            end

            node.save!
          end
        end

        def reassign_node_function_definition(node_function)
          runtime_function_definition = runtime.runtime_function_definitions.find_by(
            runtime_name: node_function.function_definition.runtime_function_definition.runtime_name
          )

          node_function.function_definition = runtime_function_definition.function_definitions.first
        end

        def reassign_node_parameter_definitions(node_parameter, function_definition)
          runtime_name = node_parameter.parameter_definition.runtime_parameter_definition.runtime_name
          runtime_parameter_definition = function_definition.runtime_function_definition.parameters.find_by(
            runtime_name: runtime_name
          )
          parameter_definition = function_definition.parameter_definitions.find_by(
            runtime_parameter_definition: runtime_parameter_definition
          )

          node_parameter.parameter_definition = parameter_definition
        end
      end
    end
  end
end
