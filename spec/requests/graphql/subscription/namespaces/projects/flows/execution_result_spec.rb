# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesProjectsFlowsExecutionResult Subscription', type: :channel do
  include AuthenticationHelpers
  include ActionCable::Channel::TestCase::Behavior

  include_context 'with graphql subscription support'

  tests GraphqlChannel

  let(:user) { create(:user) }
  let(:token) { "Session #{authorization_token(user)}" }
  let(:flow) { create(:flow) }
  let(:execution_identifier) { 'existing-execution' }

  let(:subscription_query) do
    <<~GQL
      subscription($executionIdentifier: String!) {
        namespacesProjectsFlowsExecutionResult(executionIdentifier: $executionIdentifier) {
          executionResult {
            success
            nodeResults {
              nodes {
                success
                parameterResults {
                  value
                }
              }
            }
          }
        }
      }
    GQL
  end

  before do
    create(:namespace_member, namespace: flow.project.namespace, user: user)
    stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: user, subject: flow.project)

    subscribe(token: token)
  end

  context 'when the execution result already exists' do
    before do
      result = create(
        :execution_result,
        flow: flow,
        execution_identifier: execution_identifier,
        success: { 'done' => true }
      )
      node_result = create(:execution_node_result, execution_result: result)
      create(:execution_parameter_result, execution_node_result: node_result)
    end

    it 'immediately delivers the result in the initial subscription response' do
      perform :execute, query: subscription_query, variables: { executionIdentifier: execution_identifier }

      result = transmissions.last

      execution_result = result.dig('result', 'data', 'namespacesProjectsFlowsExecutionResult', 'executionResult')
      expect(execution_result['success']).to eq({ 'done' => true })

      execution_node_result = execution_result.dig('nodeResults', 'nodes', 0)
      expect(execution_node_result['success']).to eq({ 'node' => 'ok' })
      expect(execution_node_result.dig('parameterResults', 0, 'value')).to eq({ 'parameter' => 'ok' })
    end
  end
end
