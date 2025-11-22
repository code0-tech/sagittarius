# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersDelete Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersDeleteInput!) {
        usersDelete(input: $input) {
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
    {
      userId: user.to_global_id.to_s,
    }
  end

  let(:user) { create(:user) }
  let(:variables) { { input: input } }
  let(:current_user) { create(:user, :admin) }

  before do
    post_graphql mutation, variables: variables, current_user: current_user
  end

  it 'deletes user' do
    expect(graphql_data_at(:users_delete, :user, :id)).to be_present
    expect(SagittariusSchema.object_from_id(graphql_data_at(:users_delete, :user, :id))).to be_nil

    is_expected.to create_audit_event(
      :user_deleted,
      author_id: current_user.id,
      entity_type: 'User',
      entity_id: user.id,
      details: {},
      target_type: 'global',
      target_id: 0
    )
  end

  context 'when current user lacks permission' do
    let(:current_user) { create(:user) }

    it 'returns a missing permission error' do
      expect(graphql_data_at(:users_delete, :user)).to be_nil
      expect(graphql_data_at(:users_delete, :errors, :error_code)).to include('MISSING_PERMISSION')

      expect(User.exists?(user.id)).to be true
      is_expected.not_to create_audit_event(:user_deleted)
    end
  end
end
