# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationRolesCreate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationRolesCreateInput!) {
        organizationRolesCreate(input: $input) {
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
  let(:input) do
    name = generate(:role_name)

    {
      organizationId: organization.to_global_id.to_s,
      name: name,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the organization' do
    before do
      create(:organization_member, organization: organization, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :create_organization_role, user: current_user, subject: organization)
    end

    it 'creates organization role' do
      mutate!

      expect(graphql_data_at(:organization_roles_create, :organization_role, :id)).to be_present

      organization_role = SagittariusSchema.object_from_id(
        graphql_data_at(:organization_roles_create, :organization_role, :id)
      )

      expect(organization_role.name).to eq(input[:name])
      expect(organization_role.organization).to eq(organization)

      is_expected.to create_audit_event(
        :organization_role_created,
        author_id: current_user.id,
        entity_id: organization_role.id,
        entity_type: 'OrganizationRole',
        details: { name: input[:name] },
        target_id: organization.id,
        target_type: 'Organization'
      )
    end

    context 'when organization role name is taken' do
      let(:organization_role) { create(:organization_role, organization: organization) }
      let(:input) { { organizationId: organization.to_global_id.to_s, name: organization_role.name } }

      it 'returns an error' do
        mutate!

        expect(graphql_data_at(:organization_roles_create, :organization_role)).to be_nil
        expect(
          graphql_data_at(:organization_roles_create, :errors)
        ).to include({ 'attribute' => 'name', 'type' => 'taken' })
      end
    end

    context 'when organization role name is taken in another organization' do
      let(:other_organization) do
        create(:organization).tap { |o| create(:organization_role, organization: o, name: input[:name]) }
      end

      it 'creates organization role' do
        mutate!

        expect(graphql_data_at(:organization_roles_create, :organization_role, :id)).to be_present

        organization_role = SagittariusSchema.object_from_id(
          graphql_data_at(:organization_roles_create, :organization_role, :id)
        )

        expect(organization_role.name).to eq(input[:name])
        expect(organization_role.organization).to eq(organization)

        is_expected.to create_audit_event(
          :organization_role_created,
          author_id: current_user.id,
          entity_id: organization_role.id,
          entity_type: 'OrganizationRole',
          details: { name: input[:name] },
          target_id: organization.id,
          target_type: 'Organization'
        )
      end
    end
  end

  context 'when user is not a member of the organization' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:organization_roles_create, :organization_role)).to be_nil
      expect(graphql_data_at(:organization_roles_create, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
