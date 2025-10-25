# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersLogin Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersLoginInput!) {
        usersLogin(input: $input) {
          #{error_query}
          userSession {
            id
            token
            user {
              id
              namespace {
                id
              }
            }
          }
        }
      }
    QUERY
  end

  let(:password) { generate(:password) }
  let(:user) { create(:user, :with_namespace, password: password) }
  let(:variables) { { input: input } }

  before { post_graphql mutation, variables: variables }

  context 'when input is valid' do
    context 'when using totp mfa authentication' do
      let(:user) { create(:user, :with_namespace, password: password, totp_secret: totp_secret) }
      let(:totp_secret) { ROTP::Base32.random }
      let(:totp) { ROTP::TOTP.new(totp_secret).now }

      let(:input) do
        {
          email: user.email,
          password: password,
          mfa: {
            type: 'TOTP',
            value: totp,
          },
        }
      end

      it 'creates the user session' do
        expect(graphql_data_at(:users_login, :user_session, :id)).to be_present
        expect(graphql_data_at(:users_login, :user_session, :token)).to be_present

        user_session = SagittariusSchema.object_from_id(graphql_data_at(:users_login, :user_session, :id))

        expect(user_session).to be_a(UserSession)
        expect(user_session.user.username).to eq(user.username)
        expect(user_session.user.email).to eq(user.email)

        expect(
          graphql_data_at(:users_login, :user_session, :user, :namespace)
        ).to match a_graphql_entity_for(user.namespace)

        is_expected.to create_audit_event(
          :user_logged_in,
          author_id: user.id,
          entity_id: user.id,
          details: { email: user.email, method: 'username_and_password', mfa_type: 'totp' }
        )
      end
    end

    context 'when logging in with email' do
      let(:input) do
        {
          email: user.email,
          password: password,
        }
      end

      it 'creates the user session' do
        expect(graphql_data_at(:users_login, :user_session, :id)).to be_present
        expect(graphql_data_at(:users_login, :user_session, :token)).to be_present

        user_session = SagittariusSchema.object_from_id(graphql_data_at(:users_login, :user_session, :id))

        expect(user_session).to be_a(UserSession)
        expect(user_session.user.username).to eq(user.username)
        expect(user_session.user.email).to eq(user.email)

        expect(
          graphql_data_at(:users_login, :user_session, :user, :namespace)
        ).to match a_graphql_entity_for(user.namespace)

        is_expected.to create_audit_event(
          :user_logged_in,
          author_id: user.id,
          entity_id: user.id,
          details: { email: user.email, method: 'username_and_password', mfa_type: nil }
        )
      end
    end

    context 'when logging in with username' do
      let(:input) do
        {
          username: user.username,
          password: password,
        }
      end

      it 'creates the user session' do
        expect(graphql_data_at(:users_login, :user_session, :id)).to be_present
        expect(graphql_data_at(:users_login, :user_session, :token)).to be_present

        user_session = SagittariusSchema.object_from_id(graphql_data_at(:users_login, :user_session, :id))

        expect(user_session).to be_a(UserSession)
        expect(user_session.user.username).to eq(user.username)
        expect(user_session.user.email).to eq(user.email)

        expect(
          graphql_data_at(:users_login, :user_session, :user, :namespace)
        ).to match a_graphql_entity_for(user.namespace)

        is_expected.to create_audit_event(
          :user_logged_in,
          author_id: user.id,
          entity_id: user.id,
          details: { username: user.username, method: 'username_and_password', mfa_type: nil }
        )
      end
    end
  end

  context 'when input is invalid' do
    context 'when error message matches on wrong credentials' do
      let(:input) do
        {
          username: user.username,
          password: generate(:password),
        }
      end
      let(:wrong_username_input) do
        {
          username: generate(:username),
          password: password,
        }
      end

      it 'returns same errors for username and password' do
        wrong_password_error = graphql_data_at(:users_login, :errors, :message)
        post_graphql mutation, variables: { input: wrong_username_input }
        wrong_username_error = graphql_data_at(:users_login, :errors, :message)

        expect(wrong_password_error).to eq(wrong_username_error)
      end
    end

    context 'when username and email are given' do
      let(:input) do
        {
          username: user.username,
          email: user.email,
          password: password,
        }
      end

      it 'returns errors' do
        expect(graphql_data_at(:users_login, :user_session)).not_to be_present

        expect(graphql_errors).to include(
          a_hash_including('message' => 'Only one of [:email, :username] should be provided')
        )
      end
    end

    context 'when username is invalid' do
      let(:input) do
        {
          username: generate(:username),
          password: password,
        }
      end

      it 'returns errors' do
        expect(graphql_data_at(:users_login, :user_session)).not_to be_present

        expect(graphql_data_at(:users_login, :errors, :error_code)).to include('INVALID_LOGIN_DATA')
      end
    end

    context 'when email is invalid' do
      let(:input) do
        {
          email: generate(:email),
          password: password,
        }
      end

      it 'returns errors' do
        expect(graphql_data_at(:users_login, :user_session)).not_to be_present

        expect(graphql_data_at(:users_login, :errors, :error_code)).to include('INVALID_LOGIN_DATA')
      end
    end

    context 'when password is invalid' do
      let(:input) do
        {
          username: user.username,
          password: generate(:username),
        }
      end

      it 'returns errors' do
        expect(graphql_data_at(:users_login, :user_session)).not_to be_present

        expect(graphql_data_at(:users_login, :errors, :error_code)).to include('INVALID_LOGIN_DATA')
      end
    end
  end
end
