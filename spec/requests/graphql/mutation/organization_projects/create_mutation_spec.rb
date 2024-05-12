# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationProjectsCreate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationProjectsCreateInput!) {
        organizationProjectsCreate(input: $input) {
          #{error_query}
          organizationProject {
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
    name = generate(:organization_project_name)

    {
      organizationId: organization.to_global_id.to_s,
      name: name,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  before do
    create(:organization_member, organization: organization, user: current_user)
  end

  context 'when user is a member of the organization' do
    before do
      stub_allowed_ability(OrganizationPolicy, :create_organization_project, user: current_user, subject: organization)
      stub_allowed_ability(OrganizationPolicy, :read_organization_project, user: current_user, subject: organization)
    end

    it 'creates organization project' do
      mutate!

      created_project_id = graphql_data_at(:organization_projects_create, :organization_project, :id)
      expect(created_project_id).to be_present
      organization_project = SagittariusSchema.object_from_id(
        graphql_data_at(:organization_projects_create, :organization_project, :id)
      )

      expect(organization_project.name).to eq(input[:name])
      expect(organization_project.organization).to eq(organization)

      is_expected.to create_audit_event(
        :organization_project_created,
        author_id: current_user.id,
        entity_id: organization_project.id,
        entity_type: 'OrganizationProject',
        details: { name: input[:name] },
        target_id: organization.id,
        target_type: 'Organization'
      )
    end

    context 'when organization project name is taken' do
      let(:organization_project) { create(:organization_project, organization: organization) }
      let(:input) { { organizationId: organization.to_global_id.to_s, name: organization_project.name } }

      it 'returns an error' do
        mutate!

        expect(graphql_data_at(:organization_projects_create, :organization_project)).to be_nil
        expect(
          graphql_data_at(:organization_projects_create, :errors)
        ).to include({ 'attribute' => 'name', 'type' => 'taken' })
      end
    end

    context 'when organization project name is taken in another organization' do
      before do
        stub_allowed_ability(OrganizationPolicy, :create_organization_project, user: current_user,
                                                                               subject: organization)
        stub_allowed_ability(OrganizationPolicy, :read_organization_project, user: current_user, subject: organization)
      end

      it 'creates organization project' do
        mutate!

        created_project_id = graphql_data_at(:organization_projects_create, :organization_project, :id)
        expect(created_project_id).to be_present
        organization_project = SagittariusSchema.object_from_id(
          graphql_data_at(:organization_projects_create, :organization_project, :id)
        )

        expect(organization_project.name).to eq(input[:name])
        expect(organization_project.description).to eq('')
        expect(organization_project.organization).to eq(organization)

        is_expected.to create_audit_event(
          :organization_project_created,
          author_id: current_user.id,
          entity_id: organization_project.id,
          entity_type: 'OrganizationProject',
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

      expect(graphql_data_at(:organization_projects_create, :organization_project)).to be_nil
      expect(graphql_data_at(:organization_projects_create, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
