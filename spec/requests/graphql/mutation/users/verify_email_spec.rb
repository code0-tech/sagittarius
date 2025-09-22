# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersEmailVerification Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: user }

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersEmailVerificationInput!) {
        usersEmailVerification(input: $input) {
          #{error_query}
          user {
            id
          }
        }
      }
    QUERY
  end

  let(:user) { create(:user) }

  let(:input) do
    {
      token: user.generate_token_for(:email_verification),
    }
  end

  let(:variables) { { input: input } }

  context 'when token is valid' do
    it 'creates runtime' do
      expect(user.email_verified_at).to be_nil
      mutate!

      expect(graphql_data_at(:users_email_verification, :user, :id)).to be_present
      expect(user.reload.email_verified_at).not_to be_nil

      is_expected.to create_audit_event(
        :email_verified,
        author_id: user.id,
        entity_id: user.id,
        entity_type: 'User',
        details: {
          email: user.email,
        },
        target_id: user.id,
        target_type: 'User'
      )
    end
  end
end
