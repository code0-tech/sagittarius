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

          SubscriptionTriggers.execution_result(execution_result)

          ServiceResponse.success(message: 'Execution result persisted', payload: execution_result)
        end

        private

        def build_execution_result(flow)
          result = flow.execution_results.build(
            execution_identifier: grpc_result.execution_identifier,
            input: grpc_result.input&.to_ruby(true),
            started_at: grpc_result.started_at,
            finished_at: grpc_result.finished_at
          )

          assign_result(result, grpc_result)
          build_node_results(result)

          result
        end

        def build_node_results(result)
          grpc_result.node_execution_results.each_with_index do |node_result, index|
            node_record = result.node_results.build(
              position: index,
              started_at: node_result.started_at,
              finished_at: node_result.finished_at,
              node_function: node_function_for(node_result, result.flow),
              function_definition: function_definition_for(node_result, result.flow)
            )

            assign_result(node_record, node_result)
            build_parameter_results(node_record, node_result)
          end
        end

        def build_parameter_results(node_record, node_result)
          node_result.parameter_results.each_with_index do |parameter_result, index|
            node_record.parameter_results.build(
              position: index,
              value: parameter_result.value&.to_ruby(true)
            )
          end
        end

        def flow_for
          Flow
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

        def assign_result(record, grpc_record)
          case grpc_record.result
          when :success
            record.success = grpc_record.success.to_ruby(true)
          when :error
            record.error = error_to_hash(grpc_record.error)
          end
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
