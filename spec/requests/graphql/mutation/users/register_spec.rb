# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersRegister Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersRegisterInput!) {
        usersRegister(input: $input) {
          #{error_query}
          session {
            user {
              id
            }
          }
        }
      }
    QUERY
  end

  let(:input) do
    {
      username: generate(:username),
      email: generate(:email),
      password: generate(:password),
    }
  end

  let(:variables) { { input: input } }

  before { post_graphql mutation, variables: variables }

  it 'creates the user' do
    expect(graphql_data_at(:users_register, :session, :user, :id)).to be_present

    user = SagittariusSchema.object_from_id(graphql_data_at(:users_register, :session, :user, :id))

    expect(user).to be_a(User)
    expect(user.username).to eq(input[:username])
    expect(user.email).to eq(input[:email])

    is_expected.to create_audit_event(
      :user_registered,
      author_id: user.id,
      entity_id: user.id,
      details: { username: user.username, email: user.email }
    )
  end

  context 'when the user details already exists' do
    let(:input) do
      {
        username: generate(:username),
        email: generate(:email),
        password: generate(:password),
      }
    end

    it 'returns errors' do
      post_graphql mutation, variables: variables
      expect(graphql_data_at(:users_register, :user)).not_to be_present

      expect(graphql_data_at(:users_register, :errors)).to include(
        { 'attribute' => 'username', 'type' => 'taken' },
        { 'attribute' => 'email', 'type' => 'taken' }
      )
    end
  end

  context 'when input is invalid' do
    let(:input) do
      {
        username: '',
        email: '',
        password: '',
      }
    end

    it 'returns errors' do
      expect(graphql_data_at(:users_register, :session)).not_to be_present

      expect(graphql_data_at(:users_register, :errors)).to include(
        { 'attribute' => 'password', 'type' => 'blank' },
        { 'attribute' => 'username', 'type' => 'too_short' },
        { 'attribute' => 'username', 'type' => 'blank' },
        { 'attribute' => 'email', 'type' => 'too_short' },
        { 'attribute' => 'email', 'type' => 'invalid' },
        { 'attribute' => 'email', 'type' => 'blank' }
      )
    end
  end
end
