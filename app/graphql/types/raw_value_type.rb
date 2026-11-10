# frozen_string_literal: true

module Types
  class RawValueType < Types::BaseObject
    description 'A raw JSON value returned by a node execution.'

    field :value, GraphQL::Types::JSON,
          null: true,
          description: 'The raw value as JSON.'
  end
end
