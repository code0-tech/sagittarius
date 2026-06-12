# frozen_string_literal: true

module Types
  class ExecutionParameterResultType < Types::BaseObject
    description 'Represents a parameter result of an execution node result'

    authorize :read_flow
    field :position, Integer,
          null: false,
          description: 'Position of this parameter result in the node result'
    field :value, GraphQL::Types::JSON,
          null: true,
          description: 'Value returned for this parameter'

    id_field ExecutionParameterResult
    timestamps
  end
end
