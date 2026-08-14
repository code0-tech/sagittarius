# frozen_string_literal: true

module Types
  class LiteralValueType < Types::BaseObject
    description 'Represents a literal value, such as a string or number.'

    field :value, GraphQL::Types::JSON,
          null: true,
          description: 'The literal value itself as JSON.', method: :literal_value

    field :references, [Types::InlineReferenceValueType],
          null: false,
          description: 'Inline references addressable via `${signature}` inside `value`.'

    def references
      object.try(:inline_reference_values) || []
    end
  end
end
