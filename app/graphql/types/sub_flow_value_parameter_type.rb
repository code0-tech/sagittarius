# frozen_string_literal: true

module Types
  class SubFlowValueParameterType < Types::BaseObject
    description 'Represents a sub-flow parameter.'

    field :cast, String,
          null: true,
          description: 'The cast applied to the sub-flow parameter.'
    field :identifier, String,
          null: false,
          description: 'The identifier of the sub-flow parameter.'
    field :value, Types::NodeParameterValueType,
          null: true,
          method: :value_variant,
          description: 'The value of the sub-flow parameter.'
  end
end
