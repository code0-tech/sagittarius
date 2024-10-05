# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersIdentityUnlink Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersIdentityUnlinkInput!) {
        usersIdentityUnlink(input: $input) {
          #{error_query}
          userIdentity {
            id
            identifier
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
        identityId: identity_id,
      },
    }
  end

  let(:identity) { create(:user_identity, user: current_user) }
  let(:identity_id) do
    identity.to_global_id.to_s
  end

  let(:current_user) do
    create(:user)
  end

  before { post_graphql mutation, variables: variables, current_user: current_user }

  it 'removes the user identity' do
    expect(graphql_data_at(:users_identity_unlink, :user_identity, :id)).to be_present
    expect(graphql_data_at(:users_identity_unlink, :user_identity, :user)).to be_present
    expect(graphql_data_at(:users_identity_unlink, :user_identity, :identifier)).to eq(identity.identifier)

    found_identity = SagittariusSchema.object_from_id(graphql_data_at(:users_identity_unlink, :user_identity, :id))

    expect(found_identity).to be_nil

    expect(current_user.reload.user_identities.length).to eq(0)

    is_expected.to create_audit_event(
      :user_identity_unlinked,
      author_id: current_user.id,
      entity_id: current_user.id,
      details: { provider_id: identity.provider_id, identifier: identity.identifier }
    )
  end
end
