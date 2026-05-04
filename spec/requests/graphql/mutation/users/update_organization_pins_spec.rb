# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersUpdateOrganizationPins Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersUpdateOrganizationPinsInput!) {
        usersUpdateOrganizationPins(input: $input) {
          #{error_query}
          user {
            id
            organizationPins {
              priority
            }
          }
        }
      }
    QUERY
  end

  let(:current_user) { create(:user) }
  let(:target_user) { current_user }
  let(:organization_a) { create(:organization) }
  let(:organization_b) { create(:organization) }
  let(:input) do
    {
      userId: target_user.to_global_id.to_s,
      organizationIds: [organization_a.to_global_id.to_s, organization_b.to_global_id.to_s],
    }
  end
  let(:variables) { { input: input } }

  before do
    post_graphql mutation, variables: variables, current_user: current_user
  end

  it 'updates organization pins in requested order' do
    expect(graphql_data_at(:users_update_organization_pins, :user, :id)).to eq(target_user.to_global_id.to_s)

    pins = target_user.reload.user_organization_pins.order(:priority)
    expect(pins.pluck(:organization_id)).to eq([organization_a.id, organization_b.id])
    expect(pins.pluck(:priority)).to eq([0, 1])
  end

  context 'when one organization id is invalid' do
    let(:input) do
      {
        userId: target_user.to_global_id.to_s,
        organizationIds: [organization_a.to_global_id.to_s, 'gid://sagittarius/Organization/999999'],
      }
    end

    it 'returns an error' do
      expect(graphql_data_at(:users_update_organization_pins, :user)).to be_nil
      expect(graphql_data_at(:users_update_organization_pins, :errors,
                             :error_code)).to include('ORGANIZATION_NOT_FOUND')
    end
  end
end
