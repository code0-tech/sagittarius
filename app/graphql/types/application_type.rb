# frozen_string_literal: true

module Types
  class ApplicationType < Types::BaseObject
    description 'Represents the application instance'

    field :metadata, Types::MetadataType, null: true,
                                          description: 'Metadata about the application'

    field :settings, Types::ApplicationSettingsType, null: true,
                                                     description: 'Global application settings'

    field :privacy_url, String,
          null: true,
          description: 'URL to the privacy policy page'

    field :terms_and_conditions_url, String,
          null: true,
          description: 'URL to the terms and conditions page'

    field :legal_notice_url, String,
          null: true,
          description: 'URL to the legal notice page'

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

    def privacy_url
      ApplicationSetting.current[:privacy_url]
    end

    def terms_and_conditions_url
      ApplicationSetting.current[:terms_and_conditions_url]
    end

    def legal_notice_url
      ApplicationSetting.current[:legal_notice_url]
    end
  end
end
