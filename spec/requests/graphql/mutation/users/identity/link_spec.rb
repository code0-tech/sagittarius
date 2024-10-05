# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersIdentityLink Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersIdentityLinkInput!) {
        usersIdentityLink(input: $input) {
          #{error_query}
          userIdentity {
            id
            user {
              id
            }
          }
        }
      }
    QUERY
  end

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

  let(:current_user) do
    create(:user)
  end

  def setup_identity_provider(identity)
    provider = Code0::Identities::IdentityProvider.new
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(Users::Identity::LinkService).to receive(:identity_provider).and_return(provider)
    # rubocop:enable RSpec/AnyInstance
    allow(provider).to receive(:load_identity).and_return identity
  end

  before do
    setup_identity_provider Code0::Identities::Identity.new(:google, 'identifier', 'username', 'test@code0.tech',
                                                            'firstname', 'lastname')

    post_graphql mutation, variables: variables, current_user: current_user
  end

  it 'adds the user identity' do
    expect(graphql_data_at(:users_identity_link, :user_identity, :id)).to be_present
    expect(graphql_data_at(:users_identity_link, :user_identity, :user)).to be_present

    identity = SagittariusSchema.object_from_id(graphql_data_at(:users_identity_link, :user_identity, :id))

    expect(identity).to be_a(UserIdentity)
    expect(identity.identifier).to eq('identifier')
    expect(identity.provider_id).to eq('google')

    expect(current_user.reload.user_identities.first).to eq(identity)

    is_expected.to create_audit_event(
      :user_identity_linked,
      author_id: current_user.id,
      entity_id: current_user.id,
      details: { provider_id: 'google', identifier: 'identifier' }
    )
  end
end
