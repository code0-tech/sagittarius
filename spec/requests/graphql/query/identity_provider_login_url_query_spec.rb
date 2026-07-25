# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'application identityProviderLoginUrl Query' do
  include GraphqlHelpers

  let(:query) do
    <<~QUERY
      query($id: String!) {
        application {
          identityProviderLoginUrl(id: $id)
        }
      }
    QUERY
  end

  let(:current_user) { nil }
  let(:variables) { { id: provider_id } }

  before do
    stub_application_settings(identity_providers: identity_providers)
    post_graphql(query, variables: variables, current_user: current_user)
  end

  context 'with an OIDC provider' do
    let(:provider_id) { 'my-oidc' }

    let(:identity_providers) do
      [
        {
          id: 'my-oidc',
          type: 'oidc',
          config: {
            client_id: 'oidc-client-id',
            client_secret: 'oidc-client-secret',
            redirect_uri: 'https://example.com/callback',
            user_details_url: 'https://idp.example.com/userinfo',
            authorization_url: 'https://idp.example.com/authorize?client_id={client_id}&redirect_uri={redirect_uri}',
          },
        }
      ]
    end

    it 'returns the login url with substituted parameters' do
      login_url = graphql_data_at(:application, :identity_provider_login_url)

      expect(login_url).to eq('https://idp.example.com/authorize?client_id=oidc-client-id&redirect_uri=https://example.com/callback')
    end
  end

  context 'with a SAML provider' do
    let(:provider_id) { 'my-saml' }

    let(:identity_providers) do
      [
        {
          id: 'my-saml',
          type: 'saml',
          config: {
            settings: {
              idp_sso_service_url: 'https://idp.example.com/saml/sso',
              idp_cert_fingerprint: 'AB:CD:EF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00',
              sp_entity_id: 'https://example.com/saml/metadata',
            },
          },
        }
      ]
    end

    it 'returns the login url' do
      login_url = graphql_data_at(:application, :identity_provider_login_url)

      expect(login_url).to be_present
      expect(login_url).to include('https://idp.example.com/saml/sso?SAMLRequest=')
    end
  end

  context 'when provider does not exist' do
    let(:provider_id) { 'nonexistent' }
    let(:identity_providers) { [] }

    it 'returns null' do
      login_url = graphql_data_at(:application, :identity_provider_login_url)

      expect(login_url).to be_nil
    end
  end

  context 'when querying without authentication' do
    let(:provider_id) { 'my-oidc' }

    let(:identity_providers) do
      [
        {
          id: 'my-oidc',
          type: 'oidc',
          config: {
            client_id: 'oidc-client-id',
            client_secret: 'oidc-client-secret',
            redirect_uri: 'https://example.com/callback',
            user_details_url: 'https://idp.example.com/userinfo',
            authorization_url: 'https://idp.example.com/authorize?client_id={client_id}&redirect_uri={redirect_uri}',
          },
        }
      ]
    end

    it 'returns the login url without requiring authentication' do
      login_url = graphql_data_at(:application, :identity_provider_login_url)

      expect(login_url).to be_present
    end
  end
end
