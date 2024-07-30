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
        }
      }
    QUERY
  end

  let(:current_user) { create(:user) }

  context 'when user is valid' do
    let(:current_user) { create(:user) }

    it 'generates secret' do
      mutate!
      expect(graphql_data_at(:users_mfa_totp_generate_secret, :secret)).to be_present
    end
  end
end
