# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesRolesAssignProjects Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesRolesAssignProjectsInput!) {
        namespacesRolesAssignProjects(input: $input) {
          #{error_query}
          projects {
            id
          }
        }
      }
    QUERY
  end

  let(:namespace) { create(:namespace) }
  let(:projects) { create_list(:namespace_project, 2, namespace: namespace) }
  let(:role) { create(:namespace_role, namespace: namespace) }
  let(:input) do
    {
      roleId: role.to_global_id.to_s,
      projectIds: [projects.first.to_global_id.to_s],
    }
  end
  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user has permission' do
    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_all_abilities(NamespacePolicy)
      stub_allowed_ability(NamespacePolicy, :assign_role_projects, user: current_user, subject: namespace)
      stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user, subject: projects.first)
      create(:namespace_role_project_assignment, role: role, project: projects.last)
    end

    it 'assigns the given projects to the role' do
      mutate!

      project_ids = graphql_data_at(:namespaces_roles_assign_projects, :projects, :id)
      expect(project_ids).to be_present
      expect(project_ids).to be_a(Array)

      assigned_projects = project_ids.map { |id| SagittariusSchema.object_from_id(id) }

      expect(assigned_projects).to eq([projects.first])

      is_expected.to create_audit_event(
        :namespace_role_projects_updated,
        author_id: current_user.id,
        entity_id: role.id,
        entity_type: 'NamespaceRole',
        details: {
          'new_projects' => [{ 'id' => projects.first.id, 'name' => projects.first.name }],
          'old_projects' => [{ 'id' => projects.last.id, 'name' => projects.last.name }],
        },
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end

  context 'when user does not have permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_roles_assign_projects, :projects)).to be_nil
      expect(
        graphql_data_at(:namespaces_roles_assign_projects, :errors, :error_code)
      ).to include('MISSING_PERMISSION')
    end
  end
end
