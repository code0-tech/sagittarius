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
            validation_diagnostics: validation_diagnostics(result)
          )

          UpdateRuntimesForProjectJob.perform_later(flow.project.id)

          result
        end

        private

        def validation_diagnostics(result)
          result.diagnostics.map do |diagnostic|
            {
              message: diagnostic.message,
              code: diagnostic.code,
              severity: diagnostic.severity,
              node_id: diagnostic.node_id,
              parameter_index: diagnostic.parameter_index,
            }
          end
        end
      end
    end
  end
end
