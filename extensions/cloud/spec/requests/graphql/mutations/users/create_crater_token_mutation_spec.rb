# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersCreateCraterToken Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersCreateCraterTokenInput!) {
        usersCreateCraterToken(input: $input) {
          #{error_query}
          token {
            token
            user {
              id
            }
          }
        }
      }
    QUERY
  end

  let(:variables) { { input: {} } }
  let(:current_user) { create(:user) }

  context 'when authenticated with a session' do
    before { mutate! }

    it 'creates a crater token' do
      expect(graphql_data_at(:users_create_crater_token, :token, :token)).to be_present
      expect(graphql_data_at(:users_create_crater_token, :token, :user, :id)).to eq(current_user.to_global_id.to_s)
    end
  end
end
