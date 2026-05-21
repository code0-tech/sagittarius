# frozen_string_literal: true

module Types
  class ActionStatusConfigurationEndpointType < Types::BaseObject
    description 'Detailed information about an action status'

    authorize :read_runtime

    field :endpoint, String, null: true, description: 'The endpoint URL of the action'
    field :flow_type_identifiers, [String],
          null: false,
          description: 'The flow type identifiers handled by this configuration'

    id_field ActionStatusConfiguration
    timestamps
  end
end
