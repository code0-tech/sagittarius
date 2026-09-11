# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersCompleteGuestProfile Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables }

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersCompleteGuestProfileInput!) {
        usersCompleteGuestProfile(input: $input) {
          #{error_query}
          userSession {
            token
            user {
              id
              username
            }
          }
        }
      }
    QUERY
  end

  let(:guest) { create(:user, :guest) }
  let(:claim_token) { guest.generate_token_for(:guest_claim) }
  let(:username) { generate(:username) }
  let(:password) { generate(:password) }
  let(:variables) do
    {
      input: {
        claimToken: claim_token,
        username: username,
        password: password,
        passwordRepeat: password,
      },
    }
  end

  context 'with a valid claim token' do
    before { mutate! }

    it 'completes the profile and returns a session' do
      expect(graphql_data_at(:users_complete_guest_profile, :user_session, :token)).to be_present
      expect(graphql_data_at(:users_complete_guest_profile, :user_session, :user, :username)).to eq(username)
    end

    it 'promotes the guest to a regular user' do
      expect(guest.reload).to be_regular
    end
  end

  context 'with an invalid claim token' do
    let(:claim_token) { 'invalid-token' }

    before { mutate! }

    it 'returns an error' do
      expect(graphql_data_at(:users_complete_guest_profile, :user_session)).to be_nil
      expect(graphql_data_at(:users_complete_guest_profile, :errors,
                             :error_code)).to include('INVALID_VERIFICATION_CODE')
    end
  end

  context 'when passwords do not match' do
    let(:variables) do
      {
        input: {
          claimToken: claim_token,
          username: username,
          password: password,
          passwordRepeat: "#{password}-mismatch",
        },
      }
    end

    before { mutate! }

    it 'returns an error' do
      expect(graphql_data_at(:users_complete_guest_profile, :user_session)).to be_nil
      expect(graphql_data_at(:users_complete_guest_profile, :errors, :error_code)).to include('INVALID_PASSWORD_REPEAT')
    end
  end
end
