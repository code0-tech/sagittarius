# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersMfaTotpDisable Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersMfaTotpDisableInput!) {
        usersMfaTotpDisable(input: $input) {
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
      currentTotp: current_totp,
    }
  end

  let(:variables) { { input: input } }
  let(:secret) { ROTP::Base32.random }
  let(:current_user) { create(:user, totp_secret: secret) }

  context 'when totp is valid' do
    let(:current_totp) { ROTP::TOTP.new(secret).now }

    it 'disables totp' do
      mutate!

      expect(graphql_data_at(:users_mfa_totp_disable, :user, :id)).to be_present
      expect(current_user.reload.totp_secret).to be_nil
    end
  end
end
