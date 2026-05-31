# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'execution results Query' do
  include GraphqlHelpers

  let(:namespace) { create(:namespace) }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:runtime) { create(:runtime, namespace: namespace) }
  let(:flow_type) { create(:flow_type, runtime: runtime) }
  let(:flow) { create(:flow, project: project, flow_type: flow_type) }
  let(:node_function) { create(:node_function, flow: flow) }
  let(:execution_result) do
    create(:execution_result,
           flow: flow,
           execution_identifier: 'execution-1',
           input: { 'prompt' => 'pong' },
           success: { 'ok' => true })
  end
  let(:node_result) do
    create(:execution_result_node_result,
           execution_result: execution_result,
           node_function: node_function,
           position: 0,
           success: { 'node' => 'done' })
  end
  let!(:parameter_result) do
    create(:execution_result_parameter_result,
           execution_result_node_result: node_result,
           position: 0,
           value: { 'value' => 'done' })
  end
  let(:current_user) do
    create(:user).tap do |user|
      create(:namespace_member, namespace: namespace, user: user)
    end
  end

  let(:query) do
    <<~QUERY
      query($flowId: FlowID!, $executionIdentifier: String!, $projectId: NamespaceProjectID!) {
        namespace(id: "#{namespace.to_global_id}") {
          project(id: $projectId) {
            flow(id: $flowId) {
              executionResult(executionIdentifier: $executionIdentifier) {
                id
              }
              executionResults {
                nodes {
                  id
                  input
                  success
                  error
                  flow { id }
                  nodeResults {
                    nodes {
                      id
                      position
                      success
                      error
                      nodeFunction { id }
                      parameterResults {
                        nodes {
                          id
                          position
                          value
                        }
                      }
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

  before do
    stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user, subject: project)

    post_graphql query,
                 variables: {
                   flowId: flow.to_global_id.to_s,
                   executionIdentifier: 'execution-1',
                   projectId: project.to_global_id.to_s,
                 },
                 current_user: current_user
  end

  it 'returns execution results and their nested results' do
    expect(graphql_data_at(:namespace, :project, :flow, :execution_result)).to include(
      'id' => execution_result.to_global_id.to_s
    )

    execution_node = graphql_data_at(:namespace, :project, :flow, :execution_results, :nodes, 0)
    expect(execution_node).to include(
      'id' => execution_result.to_global_id.to_s,
      'input' => { 'prompt' => 'pong' },
      'success' => { 'ok' => true },
      'error' => nil,
      'flow' => { 'id' => flow.to_global_id.to_s }
    )

    expect(execution_node.dig('nodeResults', 'nodes')).to contain_exactly(
      a_hash_including(
        'id' => node_result.to_global_id.to_s,
        'position' => 0,
        'success' => { 'node' => 'done' },
        'error' => nil,
        'nodeFunction' => { 'id' => node_function.to_global_id.to_s },
        'parameterResults' => {
          'nodes' => contain_exactly(
            a_hash_including(
              'id' => parameter_result.to_global_id.to_s,
              'position' => 0,
              'value' => { 'value' => 'done' }
            )
          ),
        }
      )
    )

    execution_nodes = graphql_data_at(:namespace, :project, :flow, :execution_results, :nodes)
    expect(execution_nodes).to contain_exactly(a_hash_including('id' => execution_result.to_global_id.to_s))
  end
end
