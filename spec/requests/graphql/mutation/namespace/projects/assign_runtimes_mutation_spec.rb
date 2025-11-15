# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesProjectsAssignRuntimes Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesProjectsAssignRuntimesInput!) {
        namespacesProjectsAssignRuntimes(input: $input) {
          #{error_query}
          namespaceProject {
            id
          }
        }
      }
    QUERY
  end

  let(:namespace) { create(:namespace) }
  let(:runtimes) { create_list(:runtime, 2, namespace: namespace) }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:input) do
    {
      namespaceProjectId: project.to_global_id.to_s,
      runtimeIds: [runtimes.first.to_global_id.to_s],
    }
  end
  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user has permission' do
    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespaceProjectPolicy, :assign_project_runtimes, user: current_user, subject: project)
      stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user, subject: project)

      create(:namespace_project_runtime_assignment, runtime: runtimes.last, namespace_project: project)
    end

    it 'assigns the given runtimes to the project' do
      mutate!

      response_project = SagittariusSchema.object_from_id(graphql_data_at(:namespaces_projects_assign_runtimes,
                                                                          :namespace_project, :id))
      expect(response_project).to be_present
      expect(response_project).to eq(project)

      is_expected.to create_audit_event(
        :project_runtimes_assigned,
        author_id: current_user.id,
        entity_id: project.id,
        entity_type: 'NamespaceProject',
        details: {
          'new_runtimes' => [{ 'id' => runtimes.first.id }],
          'old_runtimes' => [{ 'id' => runtimes.last.id }],
        },
        target_id: project.id,
        target_type: 'NamespaceProject'
      )
    end
  end

  context 'when user does not have permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_projects_assign_runtimes, :runtimes)).to be_nil
      expect(
        graphql_data_at(:namespaces_projects_assign_runtimes, :errors, :error_code)
      ).to include('MISSING_PERMISSION')
    end
  end
end
