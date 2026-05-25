# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesProjectsRuntimeAssignmentsUpdateModuleConfigurations Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesProjectsRuntimeAssignmentsUpdateModuleConfigurationsInput!) {
        namespacesProjectsRuntimeAssignmentsUpdateModuleConfigurations(input: $input) {
          #{error_query}
          namespaceProjectRuntimeAssignment {
            id
            compatible
            runtime { id }
            moduleConfigurations {
              nodes {
                id
                value
                definition {
                  id
                  identifier
                }
              }
            }
          }
        }
      }
    QUERY
  end

  let(:namespace) { create(:namespace) }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:runtime) { create(:runtime, namespace: namespace) }
  let(:runtime_assignment) do
    create(:namespace_project_runtime_assignment, namespace_project: project, runtime: runtime, compatible: true)
  end
  let(:runtime_module) { create(:runtime_module, runtime: runtime, identifier: 'core') }
  let(:definition_one) do
    create(:module_configuration_definition, runtime_module: runtime_module, identifier: 'apiKey')
  end
  let(:definition_two) do
    create(:module_configuration_definition, runtime_module: runtime_module, identifier: 'region')
  end
  let(:current_user) { create(:user) }
  let(:variables) do
    {
      input: {
        namespaceProjectRuntimeAssignmentId: runtime_assignment.to_global_id.to_s,
        moduleConfigurations: [
          {
            moduleConfigurationDefinitionId: definition_one.to_global_id.to_s,
            value: 'secret',
          },
          {
            moduleConfigurationDefinitionId: definition_two.to_global_id.to_s,
            value: 'eu-central-1',
          }
        ],
      },
    }
  end

  context 'when user has permission' do
    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespaceProjectPolicy, :assign_project_runtimes, user: current_user, subject: project)
      stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user, subject: project)
    end

    it 'persists the module configurations on the runtime assignment' do
      allow(FlowHandler).to receive(:update_runtime)

      mutate!

      response_assignment = graphql_data_at(
        :namespaces_projects_runtime_assignments_update_module_configurations,
        :namespace_project_runtime_assignment
      )

      expect(response_assignment['id']).to eq(runtime_assignment.to_global_id.to_s)
      expect(response_assignment['compatible']).to be(true)
      expect(response_assignment.dig('runtime', 'id')).to eq(runtime.to_global_id.to_s)
      expect(response_assignment.dig('moduleConfigurations', 'nodes')).to contain_exactly(
        a_hash_including(
          'value' => 'secret',
          'definition' => a_hash_including(
            'id' => definition_one.to_global_id.to_s,
            'identifier' => 'apiKey'
          )
        ),
        a_hash_including(
          'value' => 'eu-central-1',
          'definition' => a_hash_including(
            'id' => definition_two.to_global_id.to_s,
            'identifier' => 'region'
          )
        )
      )
      expect(runtime_assignment.reload.module_configurations.count).to eq(2)
      expect(FlowHandler).to have_received(:update_runtime).with(runtime)
    end
  end

  context 'when user does not have permission' do
    it 'returns an error' do
      mutate!

      expect(
        graphql_data_at(:namespaces_projects_runtime_assignments_update_module_configurations,
                        :namespace_project_runtime_assignment)
      ).to be_nil
      expect(
        graphql_data_at(:namespaces_projects_runtime_assignments_update_module_configurations, :errors, :error_code)
      ).to include('MISSING_PERMISSION')
    end
  end
end
