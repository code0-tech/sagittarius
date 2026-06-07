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
          executionResult { success }
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
      create(:execution_result, flow: flow, execution_identifier: execution_identifier, success: { 'done' => true })
    end

    it 'immediately delivers the result in the initial subscription response' do
      perform :execute, query: subscription_query, variables: { executionIdentifier: execution_identifier }

      result = transmissions.last
      expect(result.dig('result', 'data', 'namespacesProjectsFlowsExecutionResult', 'executionResult', 'success'))
        .to eq({ 'done' => true })
    end
  end
end
