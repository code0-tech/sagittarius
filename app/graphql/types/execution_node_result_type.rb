# frozen_string_literal: true

module Types
  class ExecutionNodeResultType < Types::BaseObject
    description 'Represents a node result of an execution result'

    authorize :read_flow
    declarative_policy_subject { |node_result| node_result.execution_result.flow }

    field :error, Types::ExecutionErrorType,
          null: true,
          description: 'Error returned by this node execution'
    field :finished_at, Types::TimeType,
          null: false,
          description: 'Time when this node execution finished'
    field :node_function, Types::NodeFunctionType, null: true, description: 'Node function associated with this result'
    field :parameter_results, [Types::ExecutionParameterResultType],
          null: false,
          description: 'Parameter results produced by this node execution'
    field :position, Integer,
          null: false,
          description: 'Position of this node result in the execution result'
    field :started_at, Types::TimeType,
          null: false,
          description: 'Time when this node execution started'
    field :success, GraphQL::Types::JSON,
          null: true,
          description: 'Successful value returned by this node execution'

    id_field ExecutionNodeResult
    timestamps

    def parameter_results
      object.parameter_results.order(:position)
    end
  end
end
