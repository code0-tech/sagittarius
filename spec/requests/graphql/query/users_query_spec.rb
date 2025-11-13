# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users Query' do
  include GraphqlHelpers

  subject(:query!) { post_graphql query, current_user: current_user }

  let(:query) do
    <<~QUERY
      query {
        users {
          nodes {
            id
            username
          }
        }
      }
    QUERY
  end

  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }

  context 'when anonymous' do
    let(:current_user) { nil }

    it 'returns an error' do
      query!

      expect(graphql_errors).to include(
        a_hash_including(
          'message' => 'You do not have permission to list all users'
        )
      )
    end
  end

  context 'when logged in as regular user' do
    let(:current_user) { create(:user) }

    it 'returns an error' do
      query!

      expect(graphql_errors).to include(
        a_hash_including(
          'message' => 'You do not have permission to list all users'
        )
      )
    end
  end

  context 'when logged in as admin user' do
    let(:current_user) { create(:user, :admin) }

    it 'returns all users' do
      query!

      expect(graphql_data_at(:users, :nodes)).to contain_exactly(
        a_graphql_entity_for(user1),
        a_graphql_entity_for(user2),
        a_graphql_entity_for(user3),
        a_graphql_entity_for(current_user)
      )
    end

    it 'does not return errors' do
      query!

      expect(graphql_errors).to be_nil
    end
  end
end
