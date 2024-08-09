# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description 'Represents a user'

    authorize :read_user

    field :email, String, null: false, description: 'Email of the user'
    field :username, String, null: false, description: 'Username of the user'
    field :firstname, String, null: false, description: 'Firstname of the user'
    field :lastname, String, null: false, description: 'Lastname of the user'
    field :admin, Boolean, null: false, description: 'Global admin status of the user'

    field :namespace_memberships, Types::NamespaceMemberType.connection_type,
          null: false,
          description: 'Namespace Memberships of this user',
          extras: [:lookahead]

    lookahead_field :namespace_memberships,
                    base_scope: ->(object) { object.namespace_memberships },
                    conditional_lookaheads: { user: :user, namespace: { namespace: :namespace_members } }

    id_field User
    timestamps
  end
end
