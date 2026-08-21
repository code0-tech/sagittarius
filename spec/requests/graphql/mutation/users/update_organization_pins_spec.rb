# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersUpdateOrganizationPins Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersUpdateOrganizationPinsInput!) {
        usersUpdateOrganizationPins(input: $input) {
          #{error_query}
          user {
            id
            organizationPins {
              priority
              organization {
                id
              }
            }
          }
        }
      }
    QUERY
  end

  let(:current_user) { create(:user) }
  let(:organization_a) { create(:organization) }
  let(:organization_b) { create(:organization) }

  let(:input) do
    {
      organizationIds: [organization_b.to_global_id.to_s, organization_a.to_global_id.to_s],
    }
  end
  let(:variables) { { input: input } }

  context 'when the user is a member of the given organizations' do
    before do
      [organization_a, organization_b].each do |organization|
        create(:namespace_member, namespace: organization.ensure_namespace, user: current_user)
      end
    end

    it 'updates organization pins in the requested order' do
      mutate!

      expect(graphql_data_at(:users_update_organization_pins, :user, :id)).to eq(current_user.to_global_id.to_s)

      pins = graphql_data_at(:users_update_organization_pins, :user, :organization_pins)
      expect(pins.pluck('priority')).to eq([0, 1])
      expect(pins.pluck('organization').pluck('id')).to eq(
        [organization_b.to_global_id.to_s, organization_a.to_global_id.to_s]
      )
    end
  end

  context 'when the user is not a member of an organization' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:users_update_organization_pins, :user)).to be_nil
      expect(graphql_data_at(:users_update_organization_pins, :errors, :error_code))
        .to include('ORGANIZATION_NOT_FOUND')
    end
  end
end
