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
          data_types = DataType.where(runtime: flow.project.primary_runtime)

          result = Triangulum::Validation.new(
            flow.to_grpc,
            function_definitions.map(&:to_grpc),
            data_types.map(&:to_grpc)
          ).validate

          flow.update!(
            validation_status: result.valid? ? :valid : :invalid,
            validation_diagnostics: result.diagnostics
          )

          UpdateRuntimesForProjectJob.perform_later(flow.project.id)

          result
        end
      end
    end
  end
end
