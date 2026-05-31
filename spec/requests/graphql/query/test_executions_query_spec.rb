# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'test executions Query' do
  include GraphqlHelpers

  let(:namespace) { create(:namespace) }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:runtime) { create(:runtime, namespace: namespace) }
  let(:flow_type) { create(:flow_type, runtime: runtime) }
  let(:flow) { create(:flow, project: project, flow_type: flow_type) }
  let(:node_function) { create(:node_function, flow: flow) }
  let(:test_execution) do
    create(:test_execution,
           flow: flow,
           execution_identifier: 'execution-1',
           body: { 'prompt' => 'ping' },
           input: { 'prompt' => 'pong' },
           success: { 'ok' => true })
  end
  let(:node_result) do
    create(:test_execution_node_result,
           test_execution: test_execution,
           node_function: node_function,
           node_id: node_function.id,
           position: 0,
           success: { 'node' => 'done' })
  end
  let!(:parameter_result) do
    create(:test_execution_parameter_result,
           test_execution_node_result: node_result,
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
      query($flowId: FlowID!, $executionId: TestExecutionID!, $projectId: NamespaceProjectID!) {
        testExecution(id: $executionId) {
          id
          executionIdentifier
        }
        testExecutions(flowId: $flowId) {
          nodes {
            id
            executionIdentifier
            body
            input
            success
            error
            flow { id }
            nodeResults {
              nodes {
                id
                nodeId
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
        namespace(id: "#{namespace.to_global_id}") {
          project(id: $projectId) {
            flow(id: $flowId) {
              testExecutions {
                nodes {
                  id
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
                   executionId: test_execution.to_global_id.to_s,
                   projectId: project.to_global_id.to_s,
                 },
                 current_user: current_user
  end

  it 'returns test executions and their nested results' do
    expect(graphql_data_at(:test_execution)).to include(
      'id' => test_execution.to_global_id.to_s,
      'executionIdentifier' => 'execution-1'
    )

    execution_node = graphql_data_at(:test_executions, :nodes, 0)
    expect(execution_node).to include(
      'id' => test_execution.to_global_id.to_s,
      'executionIdentifier' => 'execution-1',
      'body' => { 'prompt' => 'ping' },
      'input' => { 'prompt' => 'pong' },
      'success' => { 'ok' => true },
      'error' => nil,
      'flow' => { 'id' => flow.to_global_id.to_s }
    )

    expect(execution_node.dig('nodeResults', 'nodes')).to contain_exactly(
      a_hash_including(
        'id' => node_result.to_global_id.to_s,
        'nodeId' => node_function.id.to_s,
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

    nested_executions = graphql_data_at(:namespace, :project, :flow, :test_executions, :nodes)
    expect(nested_executions).to contain_exactly(a_hash_including('id' => test_execution.to_global_id.to_s))
  end
end
