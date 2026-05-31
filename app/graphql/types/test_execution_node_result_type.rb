# frozen_string_literal: true

module Types
  class TestExecutionNodeResultType < Types::BaseObject
    description 'Represents a node result of a test execution'

    authorize :read_flow
    declarative_policy_subject { |node_result| node_result.test_execution.flow }

    field :error, GraphQL::Types::JSON,
          null: true,
          description: 'Error returned by this node execution'
    field :finished_at, Types::TimeType,
          null: true,
          description: 'Time when this node execution finished'
    # rubocop:disable GraphQL/ExtractType -- these fields expose Tucana's node result identity directly
    field :node_function, Types::NodeFunctionType, null: true, description: 'Node function associated with this result'
    field :node_id, String, null: false, description: 'Runtime node identifier returned by Tucana'
    # rubocop:enable GraphQL/ExtractType
    field :parameter_results, Types::TestExecutionParameterResultType.connection_type,
          null: false,
          description: 'Parameter results produced by this node execution'
    field :position, Integer,
          null: false,
          description: 'Position of this node result in the execution result'
    field :started_at, Types::TimeType,
          null: true,
          description: 'Time when this node execution started'
    field :success, GraphQL::Types::JSON,
          null: true,
          description: 'Successful value returned by this node execution'

    id_field TestExecutionNodeResult
    timestamps

    def node_id
      object.node_id.to_s
    end

    def parameter_results
      object.parameter_results.order(:position)
    end
  end
end
