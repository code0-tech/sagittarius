# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'userPasswordResetRequest Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersPasswordResetRequestInput!) {
        usersPasswordResetRequest(input: $input) {
          #{error_query}
          message
        }
      }
    QUERY
  end

  let(:current_user) { create(:user, email_verified_at: Time.zone.now) }
  let(:email) { current_user.email }
  let(:input) do
    {
      email: email,
    }
  end

  let(:variables) { { input: input } }

  before do
    post_graphql mutation, variables: variables
  end

  it 'sends reset email' do
    expect(graphql_data_at(:users_password_reset_request, :message)).to be_present
    message = graphql_data_at(:users_password_reset_request, :message)

    expect(message).to eq('Sent password reset email')

    is_expected.to create_audit_event(
      :password_reset_requested,
      author_id: current_user.id,
      entity_id: current_user.id,
      entity_type: 'User',
      details: { email: current_user.email },
      target_id: current_user.id,
      target_type: 'User'
    )
  end

  context 'when users email is not verified' do
    let(:current_user) { create(:user, email_verified_at: nil) }

    it { is_expected.not_to create_audit_event(:password_reset_requested) }
  end
end
