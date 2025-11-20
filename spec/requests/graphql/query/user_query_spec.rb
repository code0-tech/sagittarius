# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user Query' do
  include GraphqlHelpers

  subject(:query!) { post_graphql query, current_user: current_user }

  let(:target_user) { create(:user) }
  let(:query) do
    <<~QUERY
      query {
        user(id: "#{target_user.to_global_id}") {
          id
          username
        }
      }
    QUERY
  end

  context 'when anonymous' do
    let(:current_user) { nil }

    it 'returns nil due to read_user authorization on UserType' do
      query!

      expect(graphql_data_at(:user)).to be_nil
    end
  end

  context 'when logged in as regular user' do
    let(:current_user) { create(:user) }

    it 'returns the user' do
      query!

      expect(graphql_data_at(:user, :id)).to eq(target_user.to_global_id.to_s)
      expect(graphql_data_at(:user, :username)).to eq(target_user.username)
    end
  end

  context 'when logged in as admin user' do
    let(:current_user) { create(:user, :admin) }

    it 'returns the user' do
      query!

      expect(graphql_data_at(:user, :id)).to eq(target_user.to_global_id.to_s)
      expect(graphql_data_at(:user, :username)).to eq(target_user.username)
    end
  end

  context 'when querying self' do
    let(:current_user) { create(:user) }
    let(:target_user) { current_user }

    it 'returns the user' do
      query!

      expect(graphql_data_at(:user, :id)).to eq(current_user.to_global_id.to_s)
      expect(graphql_data_at(:user, :username)).to eq(current_user.username)
    end
  end
end
