# frozen_string_literal: true

module Types
  class InlineReferenceValueType < Types::BaseObject
    description 'Represents a single inline reference addressable via `${signature}` inside a literal value.'

    field :signature, String, null: false, description: 'The key addressed via `${signature}`.'
    field :value, Types::NodeParameterValueType, null: false, description: 'The value this reference resolves to.',
                                                 method: :value_variant

    id_field InlineReferenceValue
    timestamps
  end
end
