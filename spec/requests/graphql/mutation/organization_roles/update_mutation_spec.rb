# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationRolesUpdate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationRolesUpdateInput!) {
        organizationRolesUpdate(input: $input) {
          #{error_query}
          organizationRole {
            id
            name
          }
        }
      }
    QUERY
  end

  let(:organization_role) { create(:organization_role) }
  let(:input) do
    name = generate(:role_name)

    {
      organizationRoleId: organization_role.to_global_id.to_s,
      name: name,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the organization' do
    before do
      create(:organization_member, organization: organization_role.organization, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :update_organization_role, user: current_user, subject: organization_role.organization)
    end

    it 'updates organization role' do
      mutate!

      expect(graphql_data_at(:organization_roles_update, :organization_role, :id)).to be_present

      organization_role = SagittariusSchema.object_from_id(
        graphql_data_at(:organization_roles_update, :organization_role, :id)
      )

      expect(organization_role.name).to eq(input[:name])

      is_expected.to create_audit_event(
        :organization_role_updated,
        author_id: current_user.id,
        entity_id: organization_role.id,
        entity_type: 'OrganizationRole',
        details: { name: input[:name] },
        target_id: organization_role.organization.id,
        target_type: 'Organization'
      )
    end

    context 'when organization role name is taken' do
      let(:existing_organization_role) { create(:organization_role, organization: organization_role.organization) }
      let(:input) { { organizationRoleId: organization_role.to_global_id.to_s, name: existing_organization_role.name } }

      it 'returns an error' do
        mutate!

        expect(graphql_data_at(:organization_roles_update, :organization_role)).to be_nil
        expect(
          graphql_data_at(:organization_roles_update, :errors)
        ).to include({ 'attribute' => 'name', 'type' => 'taken' })
      end
    end

    context 'when organization role name is taken in another organization' do
      let(:other_organization) do
        create(:organization).tap { |o| create(:organization_role, organization: o, name: input[:name]) }
      end

      it 'updates organization role' do
        mutate!

        expect(graphql_data_at(:organization_roles_update, :organization_role, :id)).to be_present

        organization_role = SagittariusSchema.object_from_id(
          graphql_data_at(:organization_roles_update, :organization_role, :id)
        )

        expect(organization_role.name).to eq(input[:name])

        is_expected.to create_audit_event(
          :organization_role_updated,
          author_id: current_user.id,
          entity_id: organization_role.id,
          entity_type: 'OrganizationRole',
          details: { name: input[:name] },
          target_id: organization_role.organization.id,
          target_type: 'Organization'
        )
      end
    end
  end

  context 'when user is not a member of the organization' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:organization_roles_update, :organization_role)).to be_nil
      expect(graphql_data_at(:organization_roles_update, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
