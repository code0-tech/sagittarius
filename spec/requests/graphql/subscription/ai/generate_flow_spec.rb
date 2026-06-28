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
  let(:runtime) { create(:runtime) }
  let(:runtime_module) { create(:runtime_module, runtime: runtime) }
  let(:runtime_function_definition) do
    create(:runtime_function_definition, runtime: runtime, runtime_module: runtime_module, runtime_name: 'sum')
  end
  let(:function_definition) do
    create(
      :function_definition,
      runtime: runtime,
      runtime_module: runtime_module,
      runtime_function_definition: runtime_function_definition,
      identifier: 'sum'
    )
  end
  let(:flow_type) do
    create(:flow_type, runtime: runtime, runtime_module: runtime_module, identifier: 'REST')
  end
  let(:flow_type_setting) { create(:flow_type_setting, flow_type: flow_type, identifier: 'region') }
  let(:parameter_definition) do
    create(
      :parameter_definition,
      function_definition: function_definition,
      runtime_parameter_definition: create(
        :runtime_parameter_definition,
        runtime_function_definition: runtime_function_definition
      )
    )
  end
  let(:flow) do
    {
      name: 'Generated flow',
      type: flow_type,
      starting_node_id: 'generated-1',
      settings: [
        {
          id: 1,
          flow_setting_identifier: 'region',
          flow_type_setting: flow_type_setting,
          value: 'eu',
          cast: nil,
        }
      ],
      nodes: [
        {
          id: 'generated-1',
          function_definition: function_definition,
          next_node_id: nil,
          parameters: [
            {
              id: 1,
              parameter_definition: parameter_definition,
              cast: nil,
              value: {
                generated_value_type: :literal_value,
                value: 1,
              },
            },
            {
              id: 2,
              parameter_definition: parameter_definition,
              cast: nil,
              value: {
                generated_value_type: :reference_value,
                id: 2,
                node_function_id: 'generated-1',
                parameter_index: 1,
                input_index: 2,
                input_type_identifier: nil,
                reference_path: [
                  {
                    id: 1,
                    path: 'result',
                    array_index: nil,
                  }
                ],
              },
            },
            {
              id: 3,
              parameter_definition: parameter_definition,
              cast: nil,
              value: {
                generated_value_type: :sub_flow_value,
                starting_node_id: 'generated-1',
                function_definition: function_definition,
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
            type {
              id
              identifier
            }
            startingNodeId
            settings {
              id
              flowSettingIdentifier
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
                  ... on AiGenerationLiteralValue {
                    value
                  }
                  ... on AiGenerationReferenceValue {
                    id
                    nodeFunctionId
                    parameterIndex
                    inputIndex
                    inputTypeIdentifier
                    referencePath {
                      path
                      arrayIndex
                    }
                  }
                  ... on AiGenerationSubFlowValue {
                    startingNodeId
                    functionDefinition {
                      id
                      identifier
                    }
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
        'type' => {
          'id' => flow_type.to_global_id.to_s,
          'identifier' => 'REST',
        },
        'startingNodeId' => 'gid://sagittarius/NodeFunction/generated-1',
        'settings' => [
          {
            'id' => 'gid://sagittarius/FlowSetting/1',
            'flowSettingIdentifier' => 'region',
            'value' => 'eu',
            'cast' => nil,
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
                'id' => 'gid://sagittarius/NodeParameter/1',
                'parameterDefinition' => {
                  'id' => parameter_definition.to_global_id.to_s,
                },
                'cast' => nil,
                'value' => {
                  '__typename' => 'AiGenerationLiteralValue',
                  'value' => 1,
                },
              },
              {
                'id' => 'gid://sagittarius/NodeParameter/2',
                'parameterDefinition' => {
                  'id' => parameter_definition.to_global_id.to_s,
                },
                'cast' => nil,
                'value' => {
                  '__typename' => 'AiGenerationReferenceValue',
                  'id' => 'gid://sagittarius/ReferenceValue/2',
                  'nodeFunctionId' => 'gid://sagittarius/NodeFunction/generated-1',
                  'parameterIndex' => 1,
                  'inputIndex' => 2,
                  'inputTypeIdentifier' => nil,
                  'referencePath' => [
                    {
                      'path' => 'result',
                      'arrayIndex' => nil,
                    }
                  ],
                },
              },
              {
                'id' => 'gid://sagittarius/NodeParameter/3',
                'parameterDefinition' => {
                  'id' => parameter_definition.to_global_id.to_s,
                },
                'cast' => nil,
                'value' => {
                  '__typename' => 'AiGenerationSubFlowValue',
                  'startingNodeId' => 'gid://sagittarius/NodeFunction/generated-1',
                  'functionDefinition' => {
                    'id' => function_definition.to_global_id.to_s,
                    'identifier' => 'sum',
                  },
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
