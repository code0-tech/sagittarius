# frozen_string_literal: true

module Types
  module Input
    class IdentityProviderConfigInputType < Types::BaseInputObject
      description 'Input for identity provider configuration. Contains fields for both OIDC and SAML.'

      # OIDC fields
      argument :authorization_url, String, required: false,
                                           description: 'The authorization URL for the OIDC identity provider'
      argument :client_id, String, required: false, description: 'The client ID for the OIDC identity provider'
      argument :client_secret, String, required: false, description: 'The client secret for the OIDC identity provider'
      argument :redirect_uri, String, required: false, description: 'The redirect URI for the OIDC identity provider'
      argument :user_details_url, String, required: false,
                                          description: 'The user details URL for the OIDC identity provider'

      # Common
      argument :attribute_statements, GraphQL::Types::JSON,
               required: false,
               description: 'List of attribute statements for the identity provider'
      argument :provider_name, String,
               required: false,
               description: 'The name of the identity provider'

      # SAML-specific fields
      argument :metadata_url, String, required: false,
                                      description: 'Optional metadata URL to fetch metadata (alternative to settings)'
      argument :response_settings, GraphQL::Types::JSON,
               required: false,
               description: 'The SAML response settings for the identity provider'
      argument :settings, GraphQL::Types::JSON, required: false,
                                                description: 'The SAML settings for the identity provider'
    end
  end
end
