# frozen_string_literal: true

module Types
  class IdentityProviderType < IdentityProviderBasicType
    description 'Represents an identity provider configuration.'

    field :config, Types::IdentityProviderConfigType, null: false,
                                                      description: 'Configuration details of the identity provider.'

    def config
      object[:config].merge(type: object[:type])
    end
  end
end
