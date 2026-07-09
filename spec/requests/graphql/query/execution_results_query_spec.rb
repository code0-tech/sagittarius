# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'execution results Query' do
  include GraphqlHelpers

  let(:namespace) { create(:namespace) }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:runtime) { create(:runtime, namespace: namespace) }
  let(:flow_type) { create(:flow_type, runtime: runtime) }
  let(:flow) { create(:flow, project: project, flow_type: flow_type, validation_message: ['Last validation failed']) }
  let(:node_function) { create(:node_function, flow: flow) }
  let(:execution_result) do
    create(:execution_result,
           flow: flow,
           execution_identifier: 'execution-1',
           input: { 'prompt' => 'pong' },
           started_at: 1_717_661_234_567_890,
           finished_at: 1_717_661_235_678_901,
           success: { 'ok' => true })
  end
  let(:node_result) do
    create(:execution_node_result,
           execution_result: execution_result,
           node_function: node_function,
           position: 0,
           started_at: 1_717_661_234_890_123,
           finished_at: 1_717_661_235_123_456,
           success: nil,
           error: {
             'code' => 'E_NODE',
             'category' => 'runtime',
             'message' => 'Node failed',
             'timestamp' => 1_717_661_234_567_890,
             'version' => '0.0.72',
             'dependencies' => { 'module' => '1.0.0' },
             'details' => { 'reason' => 'invalid' },
           })
  end
  let!(:parameter_result) do
    create(:execution_parameter_result,
           execution_node_result: node_result,
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
              validationMessage
              executionResult(executionIdentifier: $executionIdentifier) {
                id
              }
              executionResults {
                nodes {
                  id
                  input
                  startedAt
                  finishedAt
                  success
                  flow { id }
                  nodeResults {
                    nodes {
                      id
                      position
                      startedAt
                      finishedAt
                      success
                      error {
                        code
                        category
                        message
                        timestamp
                        version
                        dependencies
                        details
                      }
                      functionDefinition { id }
                      nodeFunction { id }
                      parameterResults {
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
    expect(graphql_data_at(:namespace, :project, :flow, :validation_message)).to eq(['Last validation failed'])

    expect(graphql_data_at(:namespace, :project, :flow, :execution_result)).to include(
      'id' => execution_result.to_global_id.to_s
    )

    execution_node = graphql_data_at(:namespace, :project, :flow, :execution_results, :nodes, 0)
    expect(execution_node).to include(
      'id' => execution_result.to_global_id.to_s,
      'input' => { 'prompt' => 'pong' },
      'startedAt' => 1_717_661_234_567_890,
      'finishedAt' => 1_717_661_235_678_901,
      'success' => { 'ok' => true },
      'flow' => { 'id' => flow.to_global_id.to_s }
    )

    expect(execution_node['nodeResults']['nodes']).to contain_exactly(
      a_hash_including(
        'id' => node_result.to_global_id.to_s,
        'position' => 0,
        'startedAt' => 1_717_661_234_890_123,
        'finishedAt' => 1_717_661_235_123_456,
        'success' => nil,
        'error' => {
          'code' => 'E_NODE',
          'category' => 'runtime',
          'message' => 'Node failed',
          'timestamp' => 1_717_661_234_567_890,
          'version' => '0.0.72',
          'dependencies' => { 'module' => '1.0.0' },
          'details' => { 'reason' => 'invalid' },
        },
        'functionDefinition' => nil,
        'nodeFunction' => { 'id' => node_function.to_global_id.to_s },
        'parameterResults' => contain_exactly(
          a_hash_including(
            'id' => parameter_result.to_global_id.to_s,
            'position' => 0,
            'value' => { 'value' => 'done' }
          )
        )
      )
    )

    execution_nodes = graphql_data_at(:namespace, :project, :flow, :execution_results, :nodes)
    expect(execution_nodes).to contain_exactly(a_hash_including('id' => execution_result.to_global_id.to_s))
  end
end
