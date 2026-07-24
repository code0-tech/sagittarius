# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description 'Represents a user'

    authorize :read_user

    field :avatar_path, String, null: true, description: 'The avatar if present of the user'

    field :admin, Boolean,
          null: true,
          description: 'Global admin status of the user',
          authorize: :read_admin_status
    field :blocked, Boolean,
          null: true,
          description: 'Whether the user is blocked from accessing the application',
          authorize: :read_admin_status,
          method: :blocked?
    field :email, String, null: true, description: 'Email of the user', authorize: :read_email
    field :email_verified_at, Types::TimeType,
          null: true,
          description: 'Email verification date of the user if present',
          authorize: :read_email
    field :firstname, String, null: true, description: 'Firstname of the user'
    field :lastname, String, null: true, description: 'Lastname of the user'
    field :readme, String, null: true, description: 'Readme of the user'
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

    field :organization_pins, [Types::UserOrganizationPinType],
          null: false,
          description: 'Pinned organizations of this user with explicit priority'

    field :pinned_organizations, [Types::OrganizationType],
          null: false,
          description: 'Pinned organizations of this user ordered by pin priority'

    field :mfa_status, Types::MfaStatusType,
          null: true,
          description: 'Multi-factor authentication status of this user'

    lookahead_field :namespace_memberships,
                    base_scope: ->(object) { object.namespace_memberships },
                    conditional_lookaheads: { user: :user, namespace: { namespace: :namespace_members } }

    expose_abilities %i[
      manage_mfa
      update_user
      delete_user
    ]

    id_field User
    timestamps

    def avatar_path
      return unless object.avatar.attached?

      Rails.application.routes.url_helpers.rails_storage_proxy_path object.avatar
    end

    def mfa_status
      {
        enabled: object.mfa_enabled?,
        totp_enabled: object.totp_secret.present?,
        backup_codes_count: object.backup_codes.size,
      }
    end

    def organization_pins
      object.user_organization_pins.order(priority: :asc)
    end
  end
end
