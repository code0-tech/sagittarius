# frozen_string_literal: true

module Types
  class RuntimeStatusConfigurationEndpointType < Types::BaseObject
    description 'Detailed information about a runtime status'

    authorize :read_runtime

    field :endpoint, String, null: false, description: 'The endpoint URL of the runtime'

    id_field ::RuntimeStatusConfiguration
    timestamps
  end
end
