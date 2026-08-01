# frozen_string_literal: true

module Types
  class OidcIdentityProviderConfigType < Types::BaseObject
    description 'Represents an OIDC identity provider configuration'

    markdown_documentation <<~MARKDOWN
      For more information see: <https://github.com/code0-tech/code0-identities/blob/#{Code0::Identities::VERSION}/README.md#oauth-based>
    MARKDOWN

    # rubocop:disable GraphQL/ExtractType
    field :client_id, String,
          null: false,
          description: 'The client ID for the OIDC identity provider'

    field :client_secret, String,
          null: false,
          description: 'The client secret for the OIDC identity provider'
    # rubocop:enable GraphQL/ExtractType

    field :redirect_uri, String,
          null: false,
          description: 'The redirect URI for the OIDC identity provider'

    field :provider_name, String,
          null: false,
          description: 'The name of the OIDC identity provider'

    field :user_details_url, String,
          null: true,
          description: 'The user details URL for the OIDC identity provider'

    field :authorization_url, String,
          null: true,
          description: 'The authorization URL for the OIDC identity provider'

    field :token_url, String,
          null: true,
          description: 'The token URL for the OIDC identity provider'

    field :attribute_statements, GraphQL::Types::JSON,
          null: true,
          description: 'List of attribute statements for the OIDC identity provider'

    def provider_name
      object[:provider_name] || object[:type].downcase
    end
  end
end
