# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersMfaTotpGenerateSecret Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation {
        usersMfaTotpGenerateSecret(input: {}) {
          #{error_query}
          secret
          signedSecret
        }
      }
    QUERY
  end

  let(:current_user) { create(:user) }

  context 'when user is valid' do
    let(:current_user) { create(:user) }

    it 'generates secret' do
      mutate!
      secret = graphql_data_at(:users_mfa_totp_generate_secret, :secret)
      signed_secret = graphql_data_at(:users_mfa_totp_generate_secret, :signed_secret)

      expect(secret).to be_present

      signed_totp = Rails.application.message_verifier(:totp_secret).verify(signed_secret)
      expect(signed_totp).to eq(secret)
    end
  end
end
