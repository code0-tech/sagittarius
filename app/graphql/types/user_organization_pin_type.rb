# frozen_string_literal: true

module Types
  class UserOrganizationPinType < Types::BaseObject
    description 'Represents a pinned organization of a user'

    authorize :read_user_organization_pin

    field :organization, Types::OrganizationType, null: true, description: 'The pinned organization'
    field :priority, Integer, null: false, description: 'Ordering priority of the pin'
    field :user, Types::UserType, null: false, description: 'The user owning this pin'

    id_field UserOrganizationPin
    timestamps
  end
end
