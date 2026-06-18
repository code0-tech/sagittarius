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
  let(:function_definition) { create(:function_definition, identifier: 'sum') }
  let(:parameter_definition) do
    create(
      :parameter_definition,
      function_definition: function_definition,
      runtime_parameter_definition: create(
        :runtime_parameter_definition,
        runtime_function_definition: function_definition.runtime_function_definition
      )
    )
  end
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
          function_definition: function_definition,
          next_node_id: nil,
          parameters: [
            {
              id: 'generated-parameter-1-1',
              parameter_definition: parameter_definition,
              cast: nil,
              value: 1,
            },
            {
              id: 'generated-parameter-1-2',
              parameter_definition: parameter_definition,
              cast: nil,
              value: {
                generated_value_type: :reference_value,
                id: 'generated-parameter-1-2-reference',
                node_function_id: 'generated-1',
                parameter_index: 1,
                input_index: 2,
                input_type_identifier: nil,
                reference_path: [
                  {
                    id: 'generated-parameter-1-2-reference-path-1',
                    path: 'result',
                    array_index: nil,
                  }
                ],
              },
            },
            {
              id: 'generated-parameter-1-3',
              parameter_definition: parameter_definition,
              cast: nil,
              value: {
                generated_value_type: :sub_flow_value,
                starting_node_id: 'generated-1',
                function_identifier: 'sum',
                signature: '(): undefined',
                settings: [
                  {
                    identifier: 'region',
                    default_value: 'eu',
                    optional: false,
                    hidden: true,
                  }
                ],
              },
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
              functionDefinition {
                id
                identifier
              }
              nextNodeId
              parameters {
                id
                parameterDefinition {
                  id
                }
                cast
                value {
                  __typename
                  ... on LiteralValue {
                    value
                  }
                  ... on AiGenerationReferenceValue {
                    nodeFunctionId
                    parameterIndex
                    inputIndex
                    referencePath {
                      path
                      arrayIndex
                    }
                  }
                  ... on AiGenerationSubFlowValue {
                    startingNodeId
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
            'functionDefinition' => {
              'id' => function_definition.to_global_id.to_s,
              'identifier' => 'sum',
            },
            'nextNodeId' => nil,
            'parameters' => [
              {
                'id' => 'gid://sagittarius/NodeParameter/generated-parameter-1-1',
                'parameterDefinition' => {
                  'id' => parameter_definition.to_global_id.to_s,
                },
                'cast' => nil,
                'value' => {
                  '__typename' => 'LiteralValue',
                  'value' => 1,
                },
              },
              {
                'id' => 'gid://sagittarius/NodeParameter/generated-parameter-1-2',
                'parameterDefinition' => {
                  'id' => parameter_definition.to_global_id.to_s,
                },
                'cast' => nil,
                'value' => {
                  '__typename' => 'AiGenerationReferenceValue',
                  'nodeFunctionId' => 'gid://sagittarius/NodeFunction/generated-1',
                  'parameterIndex' => 1,
                  'inputIndex' => 2,
                  'referencePath' => [
                    {
                      'path' => 'result',
                      'arrayIndex' => nil,
                    }
                  ],
                },
              },
              {
                'id' => 'gid://sagittarius/NodeParameter/generated-parameter-1-3',
                'parameterDefinition' => {
                  'id' => parameter_definition.to_global_id.to_s,
                },
                'cast' => nil,
                'value' => {
                  '__typename' => 'AiGenerationSubFlowValue',
                  'startingNodeId' => 'gid://sagittarius/NodeFunction/generated-1',
                  'signature' => '(): undefined',
                  'settings' => [
                    {
                      'identifier' => 'region',
                      'defaultValue' => 'eu',
                      'optional' => false,
                      'hidden' => true,
                    }
                  ],
                },
              }
            ],
          }
        ],
      }
    )
  end
end
