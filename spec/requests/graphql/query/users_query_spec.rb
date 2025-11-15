# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users Query' do
  include GraphqlHelpers

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

  before do
    create(:user)
    create(:user)
    create(:user)

    post_graphql query, current_user: current_user
  end

  context 'when anonymous' do
    let(:current_user) { nil }

    it 'returns an error' do
      expect(graphql_data_at(:users, :nodes)).to be_empty
    end
  end

  context 'when logged in as regular user' do
    let(:current_user) { create(:user) }

    it 'returns an error' do
      expect(graphql_data_at(:users, :nodes)).to be_empty
    end
  end

  context 'when logged in as admin user' do
    let(:current_user) { create(:user, :admin) }

    it 'returns all users' do
      expect(graphql_data_at(:users, :nodes)).to have_attributes(length: 4)
    end
  end
end
