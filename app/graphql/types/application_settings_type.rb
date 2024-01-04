# frozen_string_literal: true

module Types
  class ApplicationSettingsType < Types::BaseObject
    description 'Represents the application settings'

    authorize :read_application_setting

    field :user_registration_enabled, Boolean, null: false,
                                               description: 'Shows if user registration is enabled'

    field :team_creation_restricted, Boolean, null: false,
                                              description: 'Shows if team creation is restricted to administrators'
  end
end
