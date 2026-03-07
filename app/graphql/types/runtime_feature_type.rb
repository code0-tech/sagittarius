# frozen_string_literal: true

module Types
  class RuntimeFeatureType < Types::BaseObject
    description 'Represents a runtime feature'

    authorize :read_runtime

    field :runtime_status, Types::RuntimeStatusType,
          null: false, description: 'The runtime status this feature belongs to'

    field :descriptions, [Types::TranslationType], null: true, description: 'Description of the function'
    field :names, [Types::TranslationType], null: true, description: 'Name of the function'

    id_field RuntimeFeature
    timestamps
  end
end
