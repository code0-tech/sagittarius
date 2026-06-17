# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'aiGenerateFlow Subscription', type: :channel do
  include AuthenticationHelpers
  include ActionCable::Channel::TestCase::Behavior

  include_context 'with graphql subscription support'

  tests GraphqlChannel

  let(:user) { create(:user) }
  let(:token) { "Session #{authorization_token(user)}" }
  let(:execution_identifier) { SecureRandom.uuid }
  let(:flow) do
    {
      name: 'Generated flow',
      type: 'default',
      starting_node_id: 'generated-1',
      settings: [
        {
          id: 'generated-setting-1',
          flow_setting_id: 'region',
          value: 'eu',
          cast: 'string',
        }
      ],
      nodes: [
        {
          id: 'generated-1',
          function_identifier: 'sum',
          definition_source: 'runtime',
          next_node_id: nil,
          parameters: [
            {
              id: 'generated-parameter-1-1',
              parameter_identifier: 'left',
              cast: nil,
              value: { literal_value: 1 },
            }
          ],
        }
      ],
    }
  end
  let(:subscription_query) do
    <<~GQL
      subscription($executionIdentifier: String!) {
        aiGenerateFlow(executionIdentifier: $executionIdentifier) {
          flow {
            name
            type
            startingNodeId
            settings {
              id
              flowSettingId
              value
              cast
            }
            nodes {
              id
              functionIdentifier
              definitionSource
              nextNodeId
              parameters {
                id
                parameterIdentifier
                cast
                value {
                  literalValue
                  referenceValue {
                    nodeFunctionId
                    parameterIndex
                    inputIndex
                    referencePath {
                      path
                      arrayIndex
                    }
                  }
                  subFlowValue {
                    startingNodeId
                    functionIdentifier
                    signature
                    settings {
                      identifier
                      defaultValue
                      optional
                      hidden
                    }
                  }
                }
              }
            }
          }
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

    SubscriptionTriggers.ai_generate_flow(execution_identifier, flow)

    expect(transmissions.last).to include('more' => false)
    expect(transmissions.last.dig('result', 'data', 'aiGenerateFlow')).to eq(
      'flow' => {
        'name' => 'Generated flow',
        'type' => 'default',
        'startingNodeId' => 'gid://sagittarius/NodeFunction/generated-1',
        'settings' => [
          {
            'id' => 'gid://sagittarius/FlowSetting/generated-setting-1',
            'flowSettingId' => 'region',
            'value' => 'eu',
            'cast' => 'string',
          }
        ],
        'nodes' => [
          {
            'id' => 'gid://sagittarius/NodeFunction/generated-1',
            'functionIdentifier' => 'sum',
            'definitionSource' => 'runtime',
            'nextNodeId' => nil,
            'parameters' => [
              {
                'id' => 'gid://sagittarius/NodeParameter/generated-parameter-1-1',
                'parameterIdentifier' => 'left',
                'cast' => nil,
                'value' => {
                  'literalValue' => 1,
                  'referenceValue' => nil,
                  'subFlowValue' => nil,
                },
              }
            ],
          }
        ],
      }
    )
  end
end
