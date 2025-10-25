# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersLogout Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersLogoutInput!) {
        usersLogout(input: $input) {
          #{error_query}
          userSession {
            id
            active
          }
        }
      }
    QUERY
  end

  let(:user_session_id) { nil }
  let(:current_user) { nil }
  let(:variables) { { input: { userSessionId: user_session_id } } }

  before { post_graphql mutation, variables: variables, current_user: current_user }

  context 'when input is valid' do
    let(:user_session) { create(:user_session) }
    let(:user_session_id) { user_session.to_global_id.to_s }

    context 'when logging out a session of the same user' do
      let(:current_user) { user_session.user }

      it 'logs out the session' do
        expect(graphql_data_at(:users_logout, :user_session, :id)).to eq(user_session_id)
        expect(graphql_data_at(:users_logout, :user_session, :active)).to be(false)
      end
    end

    context 'when logging out a session of another user' do
      let(:current_user) { create(:user) }

      it 'does not log out the session' do
        expect(graphql_data_at(:users_logout, :errors, :error_code)).to include('MISSING_PERMISSION')
        expect(graphql_data_at(:users_logout, :user_session)).to be_nil
      end
    end
  end

  context 'when input is invalid' do
    let(:current_user) { create(:user) }

    context 'when session id is invalid' do
      let(:user_session_id) { 'some random string' }

      it 'raises validation error' do
        expect(graphql_errors).to include(
          a_hash_including(
            'message' => a_string_including("\"#{user_session_id}\" is not a valid Global ID")
          )
        )
      end
    end

    context 'when session id is does not exist' do
      let(:user_session_id) { 'gid://sagittarius/UserSession/0' }

      it 'raises validation error' do
        expect(graphql_data_at(:users_logout, :errors, :message)).to include('Invalid user session')
      end
    end
  end
end
