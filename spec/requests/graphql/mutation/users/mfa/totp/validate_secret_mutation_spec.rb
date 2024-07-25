# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'validateSecret Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersMfaTotpValidateSecretInput!) {
        usersMfaTotpValidateSecret(input: $input) {
          #{error_query}
          user {
            id
          }
        }
      }
    QUERY
  end

  let(:input) do
    {
      secret: signed_secret,
      currentTotp: current_totp,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is valid' do
    let(:current_user) { create(:user) }
    let(:secret) { ROTP::Base32.random }
    let(:signed_secret) { Rails.application.message_verifier(:totp_secret).generate(secret) }
    let(:current_totp) { ROTP::TOTP.new(secret).now }

    it 'generates secret' do
      mutate!

      expect(graphql_data_at(:users_mfa_totp_validate_secret, :user, :id)).to be_present
    end
  end
end
