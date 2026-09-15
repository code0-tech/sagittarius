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
          node_functions = flow.node_functions
          node_parameters = NodeParameter.where(node_function: node_functions)

          function_definitions = FunctionDefinition
                                 .by_node_function(node_functions)
                                 .or(FunctionDefinition.by_sub_flow_node_parameter(node_parameters))
                                 .preload(:runtime_function_definition)
          data_types = DataType.where(runtime: flow.project.primary_runtime)

          flow_grpc = flow.to_grpc
          function_definitions_grpc = function_definitions.map(&:to_grpc)
          data_types_grpc = data_types.map(&:to_grpc)

          result = Triangulum::Validation.new(flow_grpc, function_definitions_grpc, data_types_grpc).validate

          flow.update!(
            validation_status: result.valid? ? :valid : :invalid,
            validation_diagnostics: result.diagnostics
          )

          if result.valid?
            extract_schema(flow_grpc, function_definitions_grpc, data_types_grpc)
            UpdateFlowForProjectJob.perform_later(flow.id)
          end

          result
        end

        private

        def extract_schema(flow_grpc, function_definitions_grpc, data_types_grpc)
          schema_result = Triangulum::FlowSchemaExtraction.new(
            flow_grpc, function_definitions_grpc, data_types_grpc
          ).extract

          flow.update!(
            input_schema: schema_result.flow.input_schema,
            output_schema: schema_result.flow.output_schema
          )

          schema_result.subflow_parameters.each do |param|
            # rubocop:disable-next Rails/SkipsModelValidations -- schema fields have no validations to run
            SubFlow.where(node_parameter_id: param.id).update_all(
              input_schema: param.input_schema,
              output_schema: param.output_schema
            )
          end
        end
      end
    end
  end
end
