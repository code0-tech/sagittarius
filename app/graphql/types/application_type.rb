# frozen_string_literal: true

module Types
  class ApplicationType < Types::BaseObject
    description 'Represents the application instance'

    field :metadata, Types::MetadataType, null: false,
                                          description: 'Metadata about the application'

    field :settings, Types::ApplicationSettingsType, null: true,
                                                     description: 'Global application settings'

    expose_abilities %i[
      create_organization
      create_runtime
      delete_runtime
      update_runtime
      rotate_runtime_token
      update_application_setting
    ], subject_resolver: -> { :global }

    def metadata
      {}
    end

    def settings
      ApplicationSetting.current
    end
  end
end
