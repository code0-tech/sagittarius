# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description 'Represents a user'

    authorize :read_user

    field :avatar_path, String, null: true, description: 'The avatar if present of the user'

    field :admin, Boolean, null: false, description: 'Global admin status of the user'
    field :email, String, null: false, description: 'Email of the user'
    field :email_verified_at, Types::TimeType, null: true, description: 'Email verification date of the user if present'
    field :firstname, String, null: true, description: 'Firstname of the user'
    field :lastname, String, null: true, description: 'Lastname of the user'
    field :username, String, null: false, description: 'Username of the user'

    field :namespace_memberships, Types::NamespaceMemberType.connection_type,
          null: false,
          description: 'Namespace Memberships of this user',
          extras: [:lookahead]

    field :namespace, Types::NamespaceType,
          null: true,
          description: 'Namespace of this user',
          method: :ensure_namespace

    field :sessions, Types::UserSessionType.connection_type,
          null: false,
          description: 'Sessions of this user',
          method: :user_sessions

    field :identities, Types::UserIdentityType.connection_type,
          null: false,
          description: 'Identities of this user',
          method: :user_identities

    lookahead_field :namespace_memberships,
                    base_scope: ->(object) { object.namespace_memberships },
                    conditional_lookaheads: { user: :user, namespace: { namespace: :namespace_members } }

    id_field User
    timestamps

    def avatar_path
      return unless object.avatar.attached?

      Rails.application.routes.url_helpers.rails_storage_proxy_path object.avatar
    end
  end
end
