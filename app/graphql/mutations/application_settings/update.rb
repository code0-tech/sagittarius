# frozen_string_literal: true

module Mutations
  module ApplicationSettings
    class Update < BaseMutation
      description 'Update application settings.'

      field :application_settings, Types::ApplicationSettingsType, null: true,
                                                                   description: 'The updated application settings.'

      argument :organization_creation_restricted, Boolean,
               required: false,
               description: 'Set if organization creation is restricted to administrators.'
      argument :user_registration_enabled, Boolean,
               required: false,
               description: 'Set if user registration is enabled.'

      def resolve(params)
        ApplicationSettingsUpdateService.new(
          current_authentication,
          params
        ).execute.to_mutation_response(success_key: :application_settings)
      end
    end
  end
end
