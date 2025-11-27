# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersCreate Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersCreateInput!) {
        usersCreate(input: $input) {
          #{error_query}
          user {
            id
            email
            username
            firstname
            lastname
            admin
          }
        }
      }
    QUERY
  end

  let(:variables) { { input: input } }
  let(:password) { 'Password123!' }

  before do
    post_graphql mutation, variables: variables, current_user: current_user
  end

  context 'when creating a user as admin' do
    let(:current_user) { create(:user, :admin) }
    let(:input) do
      {
        email: generate(:email),
        username: generate(:username),
        password: password,
        passwordRepeat: password,
        firstname: 'Graph',
        lastname: 'QL',
        admin: false,
      }
    end

    it 'creates user' do
      expect(graphql_data_at(:users_create, :user, :id)).to be_present
      expect(graphql_data_at(:users_create, :user, :email)).to eq(input[:email])
      expect(graphql_data_at(:users_create, :user, :username)).to eq(input[:username])

      user = SagittariusSchema.object_from_id(graphql_data_at(:users_create, :user, :id))

      is_expected.to create_audit_event(
        :user_created,
        author_id: current_user.id,
        entity_id: user.id,
        entity_type: 'User',
        details: {
          'email' => input[:email],
          'username' => input[:username],
          'firstname' => input[:firstname],
          'lastname' => input[:lastname],
          'admin' => input[:admin],
        },
        target_id: 0,
        target_type: 'global'
      )
    end
  end

  context 'when non-admin attempts to create a user' do
    let(:current_user) { create(:user) }
    let(:input) do
      {
        email: generate(:email),
        username: generate(:username),
        password: password,
        passwordRepeat: password,
        firstname: 'Graph',
        lastname: 'QL',
        admin: false,
      }
    end

    it 'does not create user and returns an error' do
      expect(graphql_data_at(:users_create, :user)).to be_nil
      expect(graphql_data_at(:users_create, :errors)).to be_present
      is_expected.not_to create_audit_event
    end
  end

  context 'when password repeat does not match' do
    let(:current_user) { create(:user, :admin) }
    let(:input) do
      {
        email: generate(:email),
        username: generate(:username),
        password: password,
        passwordRepeat: 'mismatch',
        firstname: 'Graph',
        lastname: 'QL',
        admin: false,
      }
    end

    it 'returns a validation error and does not create the user' do
      expect(graphql_data_at(:users_create, :user)).to be_nil
      expect(graphql_data_at(:users_create, :errors)).to be_present
      is_expected.not_to create_audit_event
    end
  end
end
