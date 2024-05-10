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

  before do
    create(:organization_role, organization: organization).tap do |role|
      create(:organization_role_ability, organization_role: role, ability: :organization_administrator)
    end
  end

  context 'when user is a member of the organization' do
    before do
      create(:organization_member, organization: organization, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :delete_organization_role, user: current_user, subject: organization)
    end

    it 'deletes organization role' do
      mutate!

      expect(graphql_data_at(:organization_roles_delete, :organization_role, :id)).to be_present

      expect(
        SagittariusSchema.object_from_id(
          graphql_data_at(:organization_roles_delete, :organization_role, :id)
        )
      ).to be_nil

      is_expected.to create_audit_event(
        :organization_role_deleted,
        author_id: current_user.id,
        entity_id: organization_role.id,
        entity_type: 'OrganizationRole',
        details: {},
        target_id: organization.id,
        target_type: 'Organization'
      )
    end
  end

  context 'when user is not a member of the organization' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:organization_roles_delete, :organization_role)).to be_nil
      expect(graphql_data_at(:organization_roles_delete, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
