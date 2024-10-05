# frozen_string_literal: true

module Types
  class UserIdentityType < Types::BaseObject
    description 'Represents an external user identity'

    authorize :read_user_identity

    field :identifier, String, null: false, description: 'The description for the runtime if present'
    field :provider_id, String, null: false, description: 'The name for the runtime'
    field :user, Types::UserType, null: false, description: 'The correlating user of the identity'

    id_field UserIdentity
    timestamps
  end
end
