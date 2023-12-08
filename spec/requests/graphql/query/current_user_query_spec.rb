# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'currentUser Query' do
  include GraphqlHelpers

  let(:query) do
    <<~QUERY
      query {
        currentUser {
          id
        }
      }
    QUERY
  end

  before { post_graphql query, current_user: current_user }

  context 'when there is no current user' do
    let(:current_user) { nil }

    it 'returns nil' do
      expect(graphql_data_at(:current_user)).to be_nil
    end
  end

  context 'when there is a current user' do
    let(:current_user) { create(:user) }

    it 'returns the current user' do
      expect(graphql_data_at(:current_user, :id)).to eq(current_user.to_global_id.to_s)
    end
  end
end
