# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersUpdate Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersUpdateInput!) {
        usersUpdate(input: $input) {
          #{error_query}
          user {
            id
            username
            admin
          }
        }
      }
    QUERY
  end

  let(:input) do
    name = generate(:username)

    {
      userId: current_user.to_global_id.to_s,
      username: name,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  before do
    post_graphql mutation, variables: variables, current_user: current_user
  end

  it 'updates user' do
    expect(graphql_data_at(:users_update, :user, :id)).to be_present
    user = SagittariusSchema.object_from_id(graphql_data_at(:users_update, :user, :id))

    expect(user.username).to eq(input[:username])

    is_expected.to create_audit_event(
      :user_updated,
      author_id: current_user.id,
      entity_id: user.id,
      entity_type: 'User',
      details: { username: input[:username] },
      target_id: user.id,
      target_type: 'User'
    )
  end

  context 'when updating password' do
    context 'when password repeat is different' do
      let(:input) do
        {
          userId: current_user.to_global_id.to_s,
          password: generate(:password),
          passwordRepeat: generate(:password),
        }
      end

      it 'returns an error' do
        expect(graphql_data_at(:users_update, :user)).to be_nil
        expect(graphql_data_at(:users_update, :errors,
                               :details)).to include([{ 'message' => 'Invalid password repeat' }])
      end
    end

    context 'when password repeat is the same' do
      let(:input) do
        password = generate(:password)
        {
          userId: current_user.to_global_id.to_s,
          password: password,
          passwordRepeat: password,
        }
      end

      it 'updates the password' do
        expect(graphql_data_at(:users_update, :user, :id)).to be_present
        user = SagittariusSchema.object_from_id(graphql_data_at(:users_update, :user, :id))

        is_expected.to create_audit_event(
          :user_updated,
          author_id: current_user.id,
          entity_id: user.id,
          entity_type: 'User',
          details: {},
          target_id: user.id,
          target_type: 'User'
        )
      end
    end
  end

  context 'when updating mfa required fields' do
    context 'when mfa is not provided' do
      let(:current_user) { create(:user, :mfa_totp) }
      let(:input) do
        email = generate(:email)

        {
          userId: current_user.to_global_id.to_s,
          email: email,
        }
      end

      it 'returns an error' do
        expect(graphql_data_at(:users_update, :user)).to be_nil
        expect(graphql_data_at(:users_update, :errors, :error_code)).to include('MFA_REQUIRED')
      end
    end

    context 'when mfa is provided and valid' do
      let(:current_user) { create(:user, :mfa_totp) }
      let(:otp) { ROTP::TOTP.new(current_user.totp_secret).now }
      let(:input) do
        email = generate(:email)

        {
          userId: current_user.to_global_id.to_s,
          email: email,
          mfa: { type: 'TOTP', value: otp },
        }
      end

      it 'updates the user' do
        expect(graphql_data_at(:users_update, :user, :id)).to be_present
        user = SagittariusSchema.object_from_id(graphql_data_at(:users_update, :user, :id))

        expect(user.email).to eq(input[:email])

        is_expected.to create_audit_event(
          :user_updated,
          author_id: current_user.id,
          entity_id: user.id,
          entity_type: 'User',
          details: { email: input[:email], mfa_type: 'totp' },
          target_id: user.id,
          target_type: 'User'
        )
      end
    end
  end

  context 'when user name is taken' do
    let(:existing_user) { create(:user) }
    let(:input) do
      {
        userId: current_user.to_global_id.to_s,
        username: existing_user.username,
      }
    end

    it 'returns an error' do
      expect(graphql_data_at(:users_update, :user)).to be_nil
      expect(graphql_data_at(:users_update, :errors,
                             :details)).to include([{ 'attribute' => 'username', 'type' => 'taken' }])
    end
  end
end
