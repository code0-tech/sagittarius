# frozen_string_literal: true

module Types
  class VelorumModelType < Types::BaseObject
    description 'Represents a model available through Velorum'

    field :identifier, String, null: false, description: 'Unique model identifier'
    field :name, String, null: false, description: 'Human-readable model name'
    field :token_cost, Float, null: false, description: 'Token cost for using this model'
    field :types, [Types::VelorumModelTypeEnum],
          null: false,
          description: 'Capabilities supported by this model',
          method: :type
  end
end
