# frozen_string_literal: true

module Types
  class IdentityProviderType < Types::BaseObject
    description 'Represents an identity provider configuration.'

    field :id, String, null: false, description: 'Unique identifier of the identity provider.'
    field :type, Types::IdentityProviderTypeEnum, null: false, description: 'Type of the identity provider.'

    field :config, Types::IdentityProviderConfigType, null: false,
                                                      description: 'Configuration details of the identity provider.'

    def config
      object.config.merge(type: object.type)
    end
  end
end
