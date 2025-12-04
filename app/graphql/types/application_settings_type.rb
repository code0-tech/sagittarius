# frozen_string_literal: true

module Types
  class ApplicationSettingsType < Types::BaseObject
    description 'Represents the application settings'

    authorize :read_application_setting

    field :user_registration_enabled, Boolean, null: false,
                                               description: 'Shows if user registration is enabled'

    field :organization_creation_restricted, Boolean,
          null: false,
          description: 'Shows if organization creation is restricted to administrators'

    field :admin_status_visible, Boolean,
          null: false,
          description: 'Shows if admin status can be queried by non-administrators'

    field :identity_providers, Types::IdentityProviderType.connection_type,
          null: false,
          description: 'List of configured identity providers'
  end
end
