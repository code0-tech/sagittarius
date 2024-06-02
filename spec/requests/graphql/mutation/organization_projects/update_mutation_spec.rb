# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationProjectsUpdate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationProjectsUpdateInput!) {
        organizationProjectsUpdate(input: $input) {
          #{error_query}
          organizationProject {
            name
            description
            id
          }
        }
      }
    QUERY
  end

  let(:organization_project) { create(:organization_project) }
  let(:input) do
    name = generate(:organization_project_name)
    description = "Description for #{name}"

    {
      organizationProjectId: organization_project.to_global_id.to_s,
      name: name,
      description: description,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the organization' do
    before do
      create(:organization_member, organization: organization_project.organization, user: current_user)
      stub_allowed_ability(OrganizationProjectPolicy, :update_organization_project, user: current_user,
                                                                                    subject: organization_project)
      stub_allowed_ability(OrganizationProjectPolicy, :read_organization_project, user: current_user,
                                                                                  subject: organization_project)
    end

    it 'updates organization role' do
      mutate!

      expect(graphql_data_at(:organization_projects_update, :organization_project, :id)).to be_present

      project = SagittariusSchema.object_from_id(
        graphql_data_at(:organization_projects_update, :organization_project, :id)
      )

      expect(project.name).to eq(input[:name])
      expect(project.description).to eq(input[:description])

      is_expected.to create_audit_event(
        :organization_project_updated,
        author_id: current_user.id,
        entity_id: project.id,
        entity_type: 'OrganizationProject',
        details: { name: input[:name], description: input[:description] },
        target_id: project.id,
        target_type: 'OrganizationProject'
      )
    end

    context 'when organization project name is taken' do
      let(:existing_organization_project) do
        create(:organization_project, organization: organization_project.organization)
      end
      let(:input) do
        { organizationProjectId: organization_project.to_global_id.to_s, name: existing_organization_project.name }
      end

      it 'returns an error' do
        mutate!

        expect(graphql_data_at(:organization_projects_update, :organization_project)).to be_nil
        expect(
          graphql_data_at(:organization_projects_update, :errors)
        ).to include({ 'attribute' => 'name', 'type' => 'taken' })
      end
    end

    context 'when organization project name is taken in another organization' do
      let(:other_organization) do
        create(:organization).tap { |o| create(:organization_project, organization: o, name: input[:name]) }
      end

      it 'updates organization project' do
        mutate!

        expect(graphql_data_at(:organization_projects_update, :organization_project, :id)).to be_present

        project = SagittariusSchema.object_from_id(
          graphql_data_at(:organization_projects_update, :organization_project, :id)
        )

        expect(project.name).to eq(input[:name])
        expect(project.description).to eq(input[:description])

        is_expected.to create_audit_event(
          :organization_project_updated,
          author_id: current_user.id,
          entity_id: project.id,
          entity_type: 'OrganizationProject',
          details: { name: input[:name], description: input[:description] },
          target_id: project.id,
          target_type: 'OrganizationProject'
        )
      end
    end
  end

  context 'when user is not a member of the organization' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:organization_projects_update, :organization_role)).to be_nil
      expect(graphql_data_at(:organization_projects_update, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
