# frozen_string_literal: true

module Types
  class TestExecutionParameterResultType < Types::BaseObject
    description 'Represents a parameter result of a test execution node result'

    authorize :read_flow
    declarative_policy_subject { |parameter_result| parameter_result.test_execution_node_result.test_execution.flow }

    field :position, Integer,
          null: false,
          description: 'Position of this parameter result in the node result'
    field :value, GraphQL::Types::JSON,
          null: false,
          description: 'Value returned for this parameter'

    id_field TestExecutionParameterResult
    timestamps
  end
end
