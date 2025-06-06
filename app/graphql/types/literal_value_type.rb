# frozen_string_literal: true

module Types
  class LiteralValueType < Types::BaseObject
    description 'Represents a literal value, such as a string or number.'

    authorize :read_flow

    field :value, GraphQL::Types::JSON, null: false, description: 'The literal value itself as JSON.'

    timestamps
  end
end
