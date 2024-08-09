# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description 'Represents a user'

    authorize :read_user

    field :email, String, null: false, description: 'Email of the user'
    field :username, String, null: false, description: 'Username of the user'

    field :namespace_memberships, Types::NamespaceMemberType.connection_type,
          null: false,
          description: 'Namespace Memberships of this user',
          extras: [:lookahead]

    field :namespace, Types::NamespaceType,
          null: false,
          description: 'Namespace of this user',
          method: :ensure_namespace

    lookahead_field :namespace_memberships,
                    base_scope: ->(object) { object.namespace_memberships },
                    conditional_lookaheads: { user: :user, namespace: { namespace: :namespace_members } }

    id_field User
    timestamps
  end
end
