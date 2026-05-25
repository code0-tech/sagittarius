# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespace project runtime assignments Query' do
  include GraphqlHelpers

  let(:query) do
    <<~QUERY
      query($namespaceId: NamespaceID!, $projectId: NamespaceProjectID!) {
        namespace(id: $namespaceId) {
          project(id: $projectId) {
            id
            runtimeAssignments {
              nodes {
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
  let(:definition) { create(:module_configuration_definition, runtime_module: runtime_module, identifier: 'apiKey') }
  let!(:module_configuration) do
    create(:module_configuration,
           namespace_project_runtime_assignment: runtime_assignment,
           module_configuration_definition: definition,
           value: 'secret')
  end
  let(:current_user) do
    create(:user).tap do |user|
      create(:namespace_member, namespace: namespace, user: user)
    end
  end

  before do
    stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user, subject: project)
    stub_allowed_ability(NamespaceProjectPolicy, :assign_project_runtimes, user: current_user, subject: project)

    post_graphql query,
                 variables: {
                   namespaceId: namespace.to_global_id.to_s,
                   projectId: project.to_global_id.to_s,
                 },
                 current_user: current_user
  end

  it 'returns runtime assignments with saved module configurations' do
    response_project = graphql_data_at(:namespace, :project)
    response_assignment = response_project.dig('runtimeAssignments', 'nodes', 0)

    expect(response_project['id']).to eq(project.to_global_id.to_s)
    expect(response_assignment).to include(
      'id' => runtime_assignment.to_global_id.to_s,
      'compatible' => true,
      'runtime' => { 'id' => runtime.to_global_id.to_s }
    )
    expect(response_assignment.dig('moduleConfigurations', 'nodes')).to contain_exactly(
      a_hash_including(
        'id' => module_configuration.to_global_id.to_s,
        'value' => 'secret',
        'definition' => a_hash_including(
          'id' => definition.to_global_id.to_s,
          'identifier' => 'apiKey'
        )
      )
    )
  end
end
