# frozen_string_literal: true

module Types
  class SamlIdentityProviderConfigType < Types::BaseObject
    description 'Represents the configuration for a SAML identity provider.'

    markdown_documentation <<~QUERY
      For more information see: https://github.com/code0-tech/code0-identities/blob/#{Code0::Identities::VERSION}/README.md#saml
    QUERY

    field :provider_name, String,
          null: false,
          description: 'The name of the SAML identity provider'

    field :attribute_statements, GraphQL::Types::JSON,
          null: false,
          description: 'List of attribute statements for the SAML identity provider'

    field :settings, GraphQL::Types::JSON,
          null: false,
          description: 'The SAML settings for the identity provider'

    field :response_settings, GraphQL::Types::JSON,
          null: false,
          description: 'The SAML response settings for the identity provider'

    field :metadata_url, String,
          null: true,
          description: 'The metadata url to fetch the metadatas (replacement for settings)'
  end
end
