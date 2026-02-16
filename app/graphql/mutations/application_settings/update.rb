# frozen_string_literal: true

module Mutations
  module ApplicationSettings
    class Update < BaseMutation
      description 'Update application settings.'

      field :application, Types::ApplicationType, null: true,
                                                  description: 'The whole updated application object.'
      field :application_settings, Types::ApplicationSettingsType, null: true,
                                                                   description: 'The updated application settings.'

      argument :admin_status_visible, Boolean,
               required: false,
               description: 'Set if admin status can be queried by non-administrators.'
      argument :identity_providers, [Types::Input::IdentityProviderInputType],
               required: false,
               description: 'Set the list of configured identity providers.'
      argument :legal_notice_url, String,
               required: false,
               description: 'Set the URL to the legal notice page.'
      argument :organization_creation_restricted, Boolean,
               required: false,
               description: 'Set if organization creation is restricted to administrators.'
      argument :privacy_url, String,
               required: false,
               description: 'Set the URL to the privacy policy page.'
      argument :terms_and_conditions_url, String,
               required: false,
               description: 'Set the URL to the terms and conditions page.'
      argument :user_registration_enabled, Boolean,
               required: false,
               description: 'Set if user registration is enabled.'

      def resolve(params)
        response = ApplicationSettingsUpdateService.new(
          current_authentication,
          params
        ).execute

        return response.to_mutation_response(success_key: :application_settings) if response.error?

        response.to_mutation_response(success_key: :application_settings).merge({ application: {} })
      end
    end
  end
end
