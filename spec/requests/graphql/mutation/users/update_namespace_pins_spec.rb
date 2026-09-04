# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersUpdateNamespacePins Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersUpdateNamespacePinsInput!) {
        usersUpdateNamespacePins(input: $input) {
          #{error_query}
          user {
            id
            namespacePins {
              priority
              namespace {
                id
              }
            }
          }
        }
      }
    QUERY
  end

  let(:current_user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:organization_namespace) { organization.ensure_namespace }
  let(:personal_namespace) { current_user.ensure_namespace }

  let(:input) do
    {
      namespaceIds: [organization_namespace.to_global_id.to_s, personal_namespace.to_global_id.to_s],
    }
  end
  let(:variables) { { input: input } }

  context 'when the user is a member of the given namespaces' do
    before do
      create(:namespace_member, namespace: organization_namespace, user: current_user)
      personal_namespace
    end

    it 'updates namespace pins in the requested order, including the personal namespace' do
      mutate!

      expect(graphql_data_at(:users_update_namespace_pins, :user, :id)).to eq(current_user.to_global_id.to_s)

      pins = graphql_data_at(:users_update_namespace_pins, :user, :namespace_pins)
      expect(pins.pluck('priority')).to eq([0, 1])
      expect(pins.pluck('namespace').pluck('id')).to eq(
        [organization_namespace.to_global_id.to_s, personal_namespace.to_global_id.to_s]
      )
    end
  end

  context 'when the user is not a member of a namespace' do
    before { personal_namespace }

    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:users_update_namespace_pins, :user)).to be_nil
      expect(graphql_data_at(:users_update_namespace_pins, :errors, :error_code))
        .to include('NAMESPACE_NOT_FOUND')
    end
  end
end
