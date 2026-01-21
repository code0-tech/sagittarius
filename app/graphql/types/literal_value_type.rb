# frozen_string_literal: true

module Types
  class LiteralValueType < Types::BaseObject
    description 'Represents a literal value, such as a string or number.'

    field :value, GraphQL::Types::JSON,
          null: true,
          description: 'The literal value itself as JSON.'

    # can't use method: :itself on the field because that turns {} into null
    def value
      object
    end
  end
end
