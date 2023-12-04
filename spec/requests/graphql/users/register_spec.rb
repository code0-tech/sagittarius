# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersRegister Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersRegisterInput!) {
        usersRegister(input: $input) {
          errors
          user {
            id
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

  it 'creates the user', :aggregate_failures do
    expect(graphql_data_at(:users_register, :user, :id)).to be_present

    user = SagittariusSchema.object_from_id(graphql_data_at(:users_register, :user, :id))

    expect(user).to be_a(User)
    expect(user.username).to eq(input[:username])
    expect(user.email).to eq(input[:email])
  end

  context 'when input is invalid' do
    let(:input) do
      {
        username: '',
        email: '',
        password: '',
      }
    end

    it 'returns errors', :aggregate_failures do
      expect(graphql_data_at(:users_register, :user)).not_to be_present

      expect(graphql_data_at(:users_register, :errors)).to include(
        "Username can't be blank",
        "Email can't be blank",
        "Password can't be blank"
      )
    end
  end
end
