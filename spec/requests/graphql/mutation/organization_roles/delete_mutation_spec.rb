# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationRolesDelete Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationRolesDeleteInput!) {
        organizationRolesDelete(input: $input) {
          #{error_query}
          organizationRole {
            id
            name
            organization {
              id
            }
          }
        }
      }
    QUERY
  end

  let(:organization) { create(:organization) }
  let(:organization_role) do
    create(:organization_role, organization: organization)
  end
  let(:input) do
    {
      organizationRoleId: organization_role.to_global_id.to_s,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is not a member of the organization' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:organization_roles_delete, :organization_role)).to be_nil
      expect(graphql_data_at(:organization_roles_delete, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
