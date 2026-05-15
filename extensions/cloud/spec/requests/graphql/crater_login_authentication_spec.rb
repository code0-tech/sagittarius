# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Crater-Login authentication' do
  include GraphqlHelpers

  let(:user) { create(:user) }

  let(:query) do
    <<~QUERY
      query {
        currentUser {
          id
        }
      }
    QUERY
  end

  context 'with a valid crater login token' do
    let(:token) { user.generate_token_for(:crater_login) }

    before { post_graphql query, headers: { authorization: "Crater-Login #{token}" } }

    it 'authenticates the user' do
      expect(graphql_data_at(:current_user, :id)).to eq(user.to_global_id.to_s)
    end
  end

  context 'with an invalid crater login token' do
    before { post_graphql query, headers: { authorization: 'Crater-Login invalid-token' } }

    it 'does not authenticate' do
      expect(graphql_data_at(:current_user)).to be_nil
    end
  end
end
