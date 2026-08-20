# frozen_string_literal: true

module Types
  class ApplicationType < Types::BaseObject
    include Types::Concerns::HasUsageField

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

    # rubocop:disable GraphQL/ExtractType -- one is the list and the second one is for on-demand querying
    field :identity_providers, Types::IdentityProviderBasicType.connection_type,
          null: false,
          description: 'Configured identity providers for login and registration'

    field :identity_provider_login_url, String, null: true,
                                                description: 'Login URL for a specific identity provider' do
      argument :id, String, required: true, description: 'ID of the identity provider'
    end
    # rubocop:enable GraphQL/ExtractType

    expose_abilities %i[
      create_organization
      create_runtime
      delete_runtime
      update_runtime
      rotate_runtime_token
      update_application_setting
    ], subject_resolver: -> { :global }

    usage_field description: 'Instance-wide execution usage, bucketed by day, week or month. Only visible to admins.',
                relation: ->(_object) { UsageDailyAggregate.all },
                authorized: ->(_object) { Ability.allowed?(current_authentication, :read_application_usage, :global) },
                null: true

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

    def identity_providers
      ApplicationSetting.current[:identity_providers]
    end

    def identity_provider_login_url(id:)
      provider = Users::Identity::BaseService.new.identity_provider.providers[id]
      return nil if provider.nil?

      provider.authorization_url
    end
  end
end

Types::ApplicationType.prepend_extensions
