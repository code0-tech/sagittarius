# frozen_string_literal: true

module Types
  class TestExecutionType < Types::BaseObject
    description 'Represents a test execution'

    authorize :read_flow
    declarative_policy_subject(&:flow)

    field :body, GraphQL::Types::JSON,
          null: true,
          description: 'Request body used to start the test execution'
    field :error, GraphQL::Types::JSON,
          null: true,
          description: 'Error returned by the test execution'
    field :execution_identifier, String,
          null: false,
          description: 'Runtime identifier for the test execution'
    field :finished_at, Types::TimeType,
          null: true,
          description: 'Time when this test execution finished'
    field :flow, Types::FlowType,
          null: false,
          description: 'Flow executed by this test execution'
    field :input, GraphQL::Types::JSON,
          null: true,
          description: 'Input recorded in the test execution result'
    field :node_results, Types::TestExecutionNodeResultType.connection_type,
          null: false,
          description: 'Node results produced by this test execution'
    field :started_at, Types::TimeType,
          null: true,
          description: 'Time when this test execution started'
    field :success, GraphQL::Types::JSON,
          null: true,
          description: 'Successful value returned by the test execution'

    id_field TestExecution
    timestamps

    def node_results
      object.node_results.order(:position)
    end
  end
end
