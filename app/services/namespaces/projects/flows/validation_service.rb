# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class ValidationService
        attr_reader :flow

        def initialize(flow)
          @flow = flow
        end

        def execute
          function_definitions = FunctionDefinition
                                 .by_node_function(flow.node_functions)
                                 .preload(:runtime_function_definition)
          data_types = DataTypesFinder.new(
            {
              runtime_function_definition: function_definitions.map(&:runtime_function_definition),
              expand_recursively: true,
            }
          ).execute

          result = Triangulum::Validation.new(
            flow.to_grpc,
            function_definitions.map(&:to_grpc),
            data_types.map(&:to_grpc)
          ).validate

          if result.valid?
            flow.update!(validation_status: :valid)
          else
            flow.update!(validation_status: :invalid)
          end

          UpdateRuntimesForProjectJob.perform_later(flow.project.id)
        end
      end
    end
  end
end
