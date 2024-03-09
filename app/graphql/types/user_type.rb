# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description 'Represents a user'

    authorize :read_user

    field :email, String, null: false, description: 'Email of the user'
    field :username, String, null: false, description: 'Username of the user'

    field :organization_memberships, Types::OrganizationMemberType.connection_type,
          null: false,
          description: 'Organization Memberships of this user',
          extras: [:lookahead]

    lookahead_field :organization_memberships,
                    base_scope: ->(object) { object.organization_memberships },
                    conditional_lookaheads: { user: :user, organization: { organization: :organization_members } }

    id_field User
    timestamps
  end
end
