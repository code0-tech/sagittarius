# frozen_string_literal: true

module Types
  module Input
    class IdentityProviderInputType < Types::BaseInputObject
      description 'Input for creating or updating an identity provider'

      argument :config, Types::Input::IdentityProviderConfigInputType,
               required: true,
               description: 'Configuration for the identity provider'
      argument :id, String, required: true, description: 'Unique identifier of the identity provider'
      argument :type, Types::IdentityProviderTypeEnum, required: true, description: 'Type of the identity provider'
    end
  end
end
