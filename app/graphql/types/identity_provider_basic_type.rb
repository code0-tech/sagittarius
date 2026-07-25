# frozen_string_literal: true

module Types
  class IdentityProviderBasicType < Types::BaseObject
    description 'Represents a basic identity provider.'

    field :id, String, null: false, description: 'Unique identifier of the identity provider.'
    field :type, Types::IdentityProviderTypeEnum, null: false, description: 'Type of the identity provider.'
  end
end
