# frozen_string_literal: true

module Types
  class ApplicationType < Types::BaseObject
    description 'Represents the application with different fields '

    field :metadata, Types::MetadataType, null: false,
                                          description: 'Metadata about the application'

    field :settings, Types::ApplicationSettingsType, null: true,
                                                     description: 'Global application settings'
  end
end
