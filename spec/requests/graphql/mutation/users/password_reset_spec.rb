# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'userPasswordReset Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersPasswordResetInput!) {
        usersPasswordReset(input: $input) {
          #{error_query}
          message
        }
      }
    QUERY
  end

  let(:current_user) { create(:user) }
  let(:reset_token) { current_user.generate_token_for(:password_reset) }
  let(:new_password) { generate(:password) }
  let(:new_password_confirmation) { new_password }
  let(:input) do
    {
      resetToken: reset_token,
      newPassword: new_password,
      newPasswordConfirmation: new_password_confirmation,
    }
  end

  let(:variables) { { input: input } }

  before do
    post_graphql mutation, variables: variables
  end

  it 'updates users password' do
    expect(graphql_data_at(:users_password_reset, :message)).to be_present
    message = graphql_data_at(:users_password_reset, :message)

    expect(message).to eq('Successfully reset password')

    is_expected.to create_audit_event(
      :password_reset,
      author_id: current_user.id,
      entity_id: current_user.id,
      entity_type: 'User',
      details: {},
      target_id: current_user.id,
      target_type: 'User'
    )
  end

  context 'when users token is invalid' do
    let(:reset_token) { 'invalid' }

    it { is_expected.not_to create_audit_event(:password_reset) }
  end

  context 'when new password and confirmation do not match' do
    let(:new_password_confirmation) { 'differentpassword' }

    it 'returns validation error' do
      expect(
        graphql_data_at(:users_password_reset, :errors, :details)
      ).to include([{ 'message' => 'Invalid password repeat' }])
    end

    it { is_expected.not_to create_audit_event(:password_reset) }
  end
end
