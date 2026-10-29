# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class PersistExecutionResultService
        include Code0::ZeroTrack::Loggable

        attr_reader :grpc_result, :runtime_id

        def initialize(grpc_result, runtime_id)
          @grpc_result = grpc_result
          @runtime_id = runtime_id
        end

        def execute
          flow = flow_for
          return ServiceResponse.error(message: 'Flow not found', error_code: :flow_not_found) if flow.nil?

          execution_result = build_execution_result(flow)

          unless execution_result.save
            logger.error(message: 'Failed to persist execution result', errors: execution_result.errors.full_messages)

            return ServiceResponse.error(
              message: 'Failed to persist execution result',
              error_code: :invalid_execution_result,
              details: execution_result.errors
            )
          end

          RecordExecutionUsageService.new(execution_result).execute

          SubscriptionTriggers.execution_result(execution_result)

          ServiceResponse.success(message: 'Execution result persisted', payload: execution_result)
        end

        private

        def build_execution_result(flow)
          created_at = Time.zone.now

          result = flow.execution_results.build(
            execution_identifier: grpc_result.execution_identifier,
            input: grpc_result.input&.to_ruby(true),
            started_at: grpc_result.started_at,
            finished_at: grpc_result.finished_at,
            created_at: created_at
          )

          assign_result(result, grpc_result)
          build_node_results(result, created_at)

          result
        end

        def build_node_results(result, created_at)
          grpc_result.node_execution_results.each_with_index do |node_result, index|
            node_record = result.node_results.build(
              position: index,
              started_at: node_result.started_at,
              finished_at: node_result.finished_at,
              node_function: node_function_for(node_result, result.flow),
              function_definition: function_definition_for(node_result, result.flow),
              created_at: created_at
            )

            assign_node_result(node_record, node_result)
            build_parameter_results(node_record, node_result, created_at)
          end
        end

        def build_parameter_results(node_record, node_result, created_at)
          node_result.parameter_results.each_with_index do |parameter_result, index|
            node_record.parameter_results.build(
              position: index,
              value: node_value_raw_value(parameter_result),
              sub_flow_function_result: node_value_sub_flow_function_result(parameter_result),
              created_at: created_at
            )
          end
        end

        def flow_for
          Flow
            .includes(:project)
            .joins(project: :runtime_assignments)
            .find_by(
              id: grpc_result.flow_id,
              namespace_project_runtime_assignments: { runtime_id: runtime_id }
            )
        end

        def node_function_for(node_result, flow)
          return unless node_result.id == :node_id

          flow.node_functions.find_by(id: node_result.node_id)
        end

        def function_definition_for(node_result, flow)
          return unless node_result.id == :function_identifier

          FunctionDefinition.find_by(
            runtime: flow.project.primary_runtime,
            identifier: node_result.function_identifier
          )
        end

        # The top-level ExecutionResult still carries a plain Value for its success.
        def assign_result(record, grpc_record)
          case grpc_record.result
          when :success
            record.success = grpc_record.success.to_ruby(true)
          when :error
            record.error = error_to_hash(grpc_record.error)
          end
        end

        # A node's success is a NodeValueExecutionResult: either a raw value or a
        # sub-flow function result.
        def assign_node_result(record, node_result)
          case node_result.result
          when :success
            assign_node_success(record, node_result.success)
          when :error
            record.error = error_to_hash(node_result.error)
          end
        end

        def assign_node_success(record, node_value_result)
          case node_value_result.value
          when :raw_value
            record.success = node_value_result.raw_value&.to_ruby(true)
          when :sub_flow_function_result
            record.success_sub_flow_function_result =
              sub_flow_function_result_to_hash(node_value_result.sub_flow_function_result)
          end
        end

        def node_value_raw_value(node_value_result)
          return unless node_value_result.value == :raw_value

          node_value_result.raw_value&.to_ruby(true)
        end

        def node_value_sub_flow_function_result(node_value_result)
          return unless node_value_result.value == :sub_flow_function_result

          sub_flow_function_result_to_hash(node_value_result.sub_flow_function_result)
        end

        def sub_flow_function_result_to_hash(result)
          return if result.nil?

          {
            function: sub_flow_function_to_hash(result.function),
            input_schema: result.input_schema&.to_h,
            output_schema: result.output_schema&.to_h,
            name: result.name,
            description: result.description,
          }
        end

        def sub_flow_function_to_hash(function)
          return if function.nil?

          {
            function_identifier: function.function_identifier,
            definition_source: (function.definition_source if function.has_definition_source?),
          }
        end

        def error_to_hash(error)
          {
            code: error.code,
            category: error.category,
            message: error.message,
            timestamp: error.timestamp,
            version: error.version,
            dependencies: error.dependencies.to_h,
            details: error.details&.to_h,
          }
        end
      end
    end
  end
end
