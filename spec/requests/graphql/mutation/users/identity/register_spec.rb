# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersIdentityRegister Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersIdentityRegisterInput!) {
        usersIdentityRegister(input: $input) {
          #{error_query}
          userSession {
            id
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
      providerId: 'google',
      args: {
        code: 'a_valid_code',
      },
    }
  end

  let(:variables) { { input: input } }

  def setup_identity_provider(identity)
    provider = Code0::Identities::IdentityProvider.new
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(Users::Identity::RegisterService).to receive(:identity_provider).and_return(provider)
    # rubocop:enable RSpec/AnyInstance
    allow(provider).to receive(:load_identity).and_return identity
  end

  before do
    setup_identity_provider Code0::Identities::Identity.new(:google, 'identifier', 'username', 'test@code0.tech',
                                                            'firstname', 'lastname')

    post_graphql mutation, variables: variables
  end

  it 'creates the user session' do
    expect(graphql_data_at(:users_identity_register, :user_session, :user, :id)).to be_present

    user = SagittariusSchema.object_from_id(graphql_data_at(:users_identity_register, :user_session, :user, :id))

    expect(user).to be_present
    expect(user).to be_a(User)
    expect(user.username).to eq('username')
    expect(user.email).to eq('test@code0.tech')
    expect(user.firstname).to eq('firstname')
    expect(user.lastname).to eq('lastname')
    expect(user.user_identities.first.identifier).to eq('identifier')

    is_expected.to create_audit_event(
      :user_registered,
      author_id: user.id,
      entity_id: user.id,
      details: { provider_id: 'google', identifier: user.user_identities.first.identifier }
    )
  end
end
