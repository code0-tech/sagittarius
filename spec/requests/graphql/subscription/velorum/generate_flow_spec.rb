# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'velorumGenerateFlow Subscription', type: :channel do
  include AuthenticationHelpers
  include ActionCable::Channel::TestCase::Behavior

  include_context 'with graphql subscription support'

  tests GraphqlChannel

  let(:user) { create(:user) }
  let(:token) { "Session #{authorization_token(user)}" }
  let(:execution_identifier) { SecureRandom.uuid }
  let(:flow) { { name: 'Generated flow', type: 'default', nodes: [] } }
  let(:subscription_query) do
    <<~GQL
      subscription($executionIdentifier: String!) {
        velorumGenerateFlow(executionIdentifier: $executionIdentifier) {
          flow
        }
      }
    GQL
  end

  before do
    subscribe(token: token)
  end

  it 'delivers a generated flow for the matching execution identifier and closes the subscription' do
    perform :execute,
            query: subscription_query,
            variables: { executionIdentifier: execution_identifier }

    SubscriptionTriggers.velorum_generate_flow(execution_identifier, flow)

    expect(transmissions.last).to include('more' => false)
    expect(transmissions.last.dig('result', 'data', 'velorumGenerateFlow')).to eq(
      'flow' => { 'name' => 'Generated flow', 'type' => 'default', 'nodes' => [] }
    )
  end
end
