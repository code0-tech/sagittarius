# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersIdentityLogin Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersIdentityLoginInput!) {
        usersIdentityLogin(input: $input) {
          #{error_query}
          userSession {
            id
            token
            user {
              id
            }
          }
        }
      }
    QUERY
  end

  let(:password) { generate(:password) }
  let(:user) { create(:user, password: password) }
  let(:variables) do
    {
      input: {
        providerId: 'google',
        args: {
          code: 'code',
        },
      },
    }
  end

  def setup_identity_provider(identity)
    provider = Code0::Identities::IdentityProvider.new
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(Users::Identity::LoginService).to receive(:identity_provider).and_return(provider)
    # rubocop:enable RSpec/AnyInstance
    allow(provider).to receive(:load_identity).and_return identity
  end

  before do
    setup_identity_provider Code0::Identities::Identity.new(:google, 'identifier', 'username', 'test@code0.tech',
                                                            'firstname', 'lastname')
    create(:user_identity, user: user, identifier: 'identifier', provider_id: :google)

    post_graphql mutation, variables: variables
  end

  it 'creates the user session' do
    expect(graphql_data_at(:users_identity_login, :user_session, :id)).to be_present
    expect(graphql_data_at(:users_identity_login, :user_session, :token)).to be_present

    user_session = SagittariusSchema.object_from_id(graphql_data_at(:users_identity_login, :user_session, :id))

    expect(user_session).to be_a(UserSession)
    expect(user_session.user.username).to eq(user.username)
    expect(user_session.user.email).to eq(user.email)

    is_expected.to create_audit_event(
      :user_logged_in,
      author_id: user.id,
      entity_id: user.id,
      details: { provider_id: 'google', identifier: 'identifier' }
    )
  end
end
