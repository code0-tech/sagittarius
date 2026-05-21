# frozen_string_literal: true

module Types
  class AdapterStatusConfigurationEndpointType < Types::BaseObject
    description 'Detailed information about an adapter status'

    authorize :read_runtime

    field :endpoint, String, null: true, description: 'The endpoint URL of the adapter'
    field :flow_type_identifiers, [String],
          null: false,
          description: 'The flow type identifiers handled by this configuration'

    id_field ::AdapterStatusConfiguration
    timestamps
  end
end
