# frozen_string_literal: true

module Types
  class ExecutionResultType < Types::BaseObject
    description 'Represents an execution result'

    authorize :read_flow
    declarative_policy_subject(&:flow)

    field :error, Types::ExecutionErrorType,
          null: true,
          description: 'Error returned by the execution result'
    field :finished_at, Types::TimeType,
          null: false,
          description: 'Time when this execution result finished'
    field :flow, Types::FlowType,
          null: false,
          description: 'Flow executed by this execution result'
    field :input, GraphQL::Types::JSON,
          null: true,
          description: 'Input recorded in the execution result'
    field :node_results, [Types::ExecutionResultNodeResultType],
          null: false,
          description: 'Node results produced by this execution result'
    field :started_at, Types::TimeType,
          null: false,
          description: 'Time when this execution result started'
    field :success, GraphQL::Types::JSON,
          null: true,
          description: 'Successful value returned by the execution result'

    id_field ExecutionResult
    timestamps

    def node_results
      object.node_results.order(:position)
    end
  end
end
