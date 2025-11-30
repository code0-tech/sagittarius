# frozen_string_literal: true

module Types
  class OidcIdentityProviderConfigType < Types::BaseObject
    description 'Represents an OIDC identity provider configuration'

    markdown_documentation <<~QUERY
      For more information see: https://github.com/code0-tech/code0-identities/blob/#{Code0::Identities::VERSION}/README.md#oauth-based
    QUERY

    # rubocop:disable Graphql/ExtractType
    field :client_id, String,
          null: false,
          description: 'The client ID for the OIDC identity provider'

    field :client_secret, String,
          null: false,
          description: 'The client secret for the OIDC identity provider'
    # rubocop:enable Graphql/ExtractType

    field :redirect_uri, String,
          null: false,
          description: 'The redirect URI for the OIDC identity provider'

    field :provider_name, String,
          null: false,
          description: 'The name of the OIDC identity provider'

    field :user_details_url, String,
          null: false,
          description: 'The user details URL for the OIDC identity provider'

    field :authorization_url, String,
          null: false,
          description: 'The authorization URL for the OIDC identity provider'

    field :attribute_statements, GraphQL::Types::JSON,
          null: false,
          description: 'List of attribute statements for the OIDC identity provider'
  end
end
