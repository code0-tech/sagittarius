# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'velorumGenerateFlow Subscription', type: :channel do
  include AuthenticationHelpers
  include ActionCable::Channel::TestCase::Behavior

  include_context 'with graphql subscription support'

  tests GraphqlChannel

  let(:user) { create(:user) }
  let(:token) { "Session #{authorization_token(user)}" }
  let(:generation_id) { SecureRandom.uuid }
  let(:flow) { { name: 'Generated flow', type: 'default', nodes: [] } }
  let(:subscription_query) do
    <<~GQL
      subscription($id: String!) {
        velorumGenerateFlow(id: $id) {
          flow
        }
      }
    GQL
  end

  before do
    subscribe(token: token)
  end

  it 'delivers a generated flow for the matching id and closes the subscription' do
    perform :execute,
            query: subscription_query,
            variables: { id: generation_id }

    SubscriptionTriggers.velorum_generate_flow(generation_id, flow)

    expect(transmissions.last).to include('more' => false)
    expect(transmissions.last.dig('result', 'data', 'velorumGenerateFlow')).to eq(
      'flow' => { 'name' => 'Generated flow', 'type' => 'default', 'nodes' => [] }
    )
  end
end
