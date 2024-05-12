# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationRolesAssignAbilities Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationRolesAssignAbilitiesInput!) {
        organizationRolesAssignAbilities(input: $input) {
          #{error_query}
          abilities
        }
      }
    QUERY
  end
  let(:organization_role) { create(:organization_role) }
  let(:input) do
    {
      roleId: organization_role.to_global_id.to_s,
      abilities: ['CREATE_ORGANIZATION_ROLE'],
    }
  end
  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  before do
    create(:organization_role, organization: organization_role.organization).tap do |role|
      create(:organization_role_ability, organization_role: role, ability: :organization_administrator)
    end
  end

  context 'when user has permission' do
    before do
      stub_allowed_ability(
        OrganizationPolicy,
        :assign_role_abilities,
        user: current_user,
        subject: organization_role.organization
      )
    end

    it 'assigns the given abilities to the role' do
      mutate!

      abilities = graphql_data_at(:organization_roles_assign_abilities, :abilities)
      expect(abilities).to be_present
      expect(abilities).to be_a(Array)

      expect(abilities).to eq(['CREATE_ORGANIZATION_ROLE'])

      is_expected.to create_audit_event(
        :organization_role_abilities_updated,
        author_id: current_user.id,
        entity_id: organization_role.id,
        entity_type: 'OrganizationRole',
        details: {
          'new_abilities' => ['create_organization_role'],
          'old_abilities' => [],
        },
        target_id: organization_role.organization.id,
        target_type: 'Organization'
      )
    end
  end

  context 'when user does not have permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:organization_roles_assign_abilities, :abilities)).to be_nil
      expect(
        graphql_data_at(:organization_roles_assign_abilities, :errors)
      ).to include({ 'message' => 'missing_permission' })
    end
  end
end
