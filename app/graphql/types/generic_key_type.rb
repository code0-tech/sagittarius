# frozen_string_literal: true

module Types
  class GenericKeyType < Types::BaseObject
    description 'Represents a key for a generic value.'

    authorize :read_flow

    field :generic_key, String, null: false, description: 'The key of the generic value.'

    timestamps
  end
end
