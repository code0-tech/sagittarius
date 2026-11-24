# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesProjectsFlowsExecution Subscription', type: :channel do
  include AuthenticationHelpers
  include ActionCable::Channel::TestCase::Behavior

  include_context 'with graphql subscription support'

  tests GraphqlChannel

  let(:user) { create(:user) }
  let(:token) { "Session #{authorization_token(user)}" }
  let(:flow) { create(:flow) }

  let(:subscription_query) do
    <<~GQL
      subscription($flowId: FlowID!) {
        namespacesProjectsFlowsExecution(flowId: $flowId) {
          executionIdentifier
        }
      }
    GQL
  end

  before do
    create(:namespace_member, namespace: flow.project.namespace, user: user)
    stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: user, subject: flow.project)

    subscribe(token: token)
  end

  context 'when subscribing' do
    it 'does not deliver an execution identifier in the initial subscription response' do
      perform :execute, query: subscription_query, variables: { flowId: flow.to_global_id.to_s }

      execution_result = transmissions.last.dig('result', 'data', 'namespacesProjectsFlowsExecution')
      expect(execution_result).to be_nil
    end
  end

  context 'when a new execution result is persisted for the flow after subscribing' do
    it 'streams the execution identifier to the subscriber' do
      perform :execute, query: subscription_query, variables: { flowId: flow.to_global_id.to_s }

      result = create(:execution_result, flow: flow, success: { 'first' => true })
      SubscriptionTriggers.execution_result(result)

      first_transmission = transmissions.last
      execution_identifier = first_transmission.dig(
        'result',
        'data',
        'namespacesProjectsFlowsExecution',
        'executionIdentifier'
      )
      expect(execution_identifier).to eq(result.execution_identifier)

      other_result = create(:execution_result, flow: flow, success: { 'second' => true })
      SubscriptionTriggers.execution_result(other_result)

      second_transmission = transmissions.last
      second_execution_identifier = second_transmission.dig(
        'result',
        'data',
        'namespacesProjectsFlowsExecution',
        'executionIdentifier'
      )
      expect(second_execution_identifier).to eq(other_result.execution_identifier)
    end
  end

  context 'when a result for a different flow is triggered' do
    it 'does not deliver the execution identifier to the subscriber' do
      perform :execute, query: subscription_query, variables: { flowId: flow.to_global_id.to_s }
      transmission_count_before_trigger = transmissions.count

      other_flow = create(:flow)
      result = create(:execution_result, flow: other_flow, success: { 'done' => true })
      SubscriptionTriggers.execution_result(result)

      expect(transmissions.count).to eq(transmission_count_before_trigger)
    end
  end
end
