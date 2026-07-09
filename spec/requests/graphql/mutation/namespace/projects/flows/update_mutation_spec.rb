# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesProjectsFlowsUpdate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesProjectsFlowsUpdateInput!) {
        namespacesProjectsFlowsUpdate(input: $input) {
          #{error_query}
          flow {
            id
            startingNodeId
            nodes {
              count
              nodes {
                id
                parameters {
                  count
                  nodes {
                    id
                    value {
                      __typename
                      ...on LiteralValue {
                        value
                      }
                      ...on SubFlowValue {
                        functionDefinition {
                          id
                          identifier
                        }
                        signature
                        startingNodeId
                      }
                      ...on ReferenceValue {
                        createdAt
                        id
                        nodeFunctionId
                        referencePath {
                          arrayIndex
                          id
                          path
                        }
                        parameterIndex
                        inputIndex
                        updatedAt
                      }
                    }
                  }
                }
              }
            }
            settings {
              nodes {
                flowSettingIdentifier
                id
                value
              }
            }
          }
        }
      }
    QUERY
  end

  let(:runtime) { create(:runtime) }
  let(:project) { create(:namespace_project, primary_runtime: runtime) }
  let(:flow_type) do
    create(:flow_type, runtime: runtime).tap do |ft|
      create(:flow_type_setting, flow_type: ft, identifier: 'setting')
    end
  end
  let(:flow) { create(:flow, project: project, flow_type: flow_type) }
  let(:function_definition) do
    rfd = create(:runtime_function_definition, runtime: runtime)
    rpd = create(:runtime_parameter_definition, runtime_function_definition: rfd)

    create(:function_definition, runtime_function_definition: rfd).tap do |fd|
      create(:parameter_definition, runtime_parameter_definition: rpd, function_definition: fd)
      create(:parameter_definition, runtime_parameter_definition: rpd, function_definition: fd)
    end
  end

  let(:input) do
    {
      flowId: flow.to_global_id.to_s,
      flowInput: {
        name: generate(:flow_name),
        type: flow_type.to_global_id.to_s,
        startingNodeId: 'gid://sagittarius/NodeFunction/1000',
        settings: {
          value: {
            'key' => 'value',
          },
        },
        nodes: [
          {
            id: 'gid://sagittarius/NodeFunction/2000',
            functionDefinitionId: function_definition.to_global_id.to_s,
            nextNodeId: nil,
            parameters: [
              {
                value: {
                  literalValue: 100,
                },
              }
            ],
          },
          {
            id: 'gid://sagittarius/NodeFunction/1000',
            functionDefinitionId: function_definition.to_global_id.to_s,
            parameters: [
              {
                value: {
                  subFlowValue: {
                    startingNodeId: 'gid://sagittarius/NodeFunction/2000',
                    signature: '(input: INPUT): OUTPUT',
                  },
                },
              }
            ],
            nextNodeId: 'gid://sagittarius/NodeFunction/1001',
          },
          {
            id: 'gid://sagittarius/NodeFunction/1001',
            functionDefinitionId: function_definition.to_global_id.to_s,
            parameters: [
              {
                value: {
                  referenceValue: {
                    referencePath: [
                      {
                        arrayIndex: 0,
                        path: 'some.path',
                      }
                    ],
                    nodeFunctionId: 'gid://sagittarius/NodeFunction/2000',
                    parameterIndex: 1,
                    inputIndex: 1,
                  },
                },
              },
              {
                value: {
                  referenceValue: {
                    referencePath: [
                      {
                        arrayIndex: 1,
                        path: 'some.path',
                      }
                    ],
                  },
                },
              }
            ],
          }
        ],
      },
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user has the permission' do
    before do
      stub_allowed_ability(NamespaceProjectPolicy, :update_flow, user: current_user, subject: project)
      stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user, subject: project)
    end

    it 'updates flow' do
      mutate!

      updated_flow_id = graphql_data_at(:namespaces_projects_flows_update, :flow, :id)
      expect(updated_flow_id).to be_present
      flow = SagittariusSchema.object_from_id(updated_flow_id)

      expect(
        graphql_data_at(:namespaces_projects_flows_update, :flow)
      ).to match a_graphql_entity_for(
        flow,
        starting_node_id: flow.starting_node.to_global_id.to_s
      )

      expect(graphql_data_at(:namespaces_projects_flows_update, :flow, :settings).size).to eq(1)
      expect(
        graphql_data_at(:namespaces_projects_flows_update, :flow, :settings, :nodes).first
      ).to match a_hash_including(
        'flowSettingIdentifier' => flow_type.flow_type_settings.first.identifier,
        'value' => input[:flowInput][:settings][:value]
      )

      nodes = graphql_data_at(:namespaces_projects_flows_update, :flow, :nodes, :nodes)
      starting_node = nodes.find do |n|
        n['id'] == graphql_data_at(:namespaces_projects_flows_update, :flow, :starting_node_id)
      end
      expect(starting_node['parameters']['count']).to eq(1)

      expect(flow).to be_present
      expect(project.flows).to include(flow)
      expect(flow.node_functions.count).to eq(3)

      parameter_values = graphql_data_at(
        :namespaces_projects_flows_update,
        :flow,
        :nodes,
        :nodes,
        :parameters,
        :nodes,
        :value
      )
      expect(parameter_values).to include(
        a_hash_including(
          '__typename' => 'LiteralValue',
          'value' => 100
        )
      )
      expect(parameter_values).to include(
        a_hash_including(
          '__typename' => 'SubFlowValue',
          'signature' => '(input: INPUT): OUTPUT',
          'startingNodeId' => a_string_matching(%r{gid://sagittarius/NodeFunction/\d+})
        )
      )
      expect(parameter_values).to include(
        a_hash_including(
          '__typename' => 'ReferenceValue',
          'nodeFunctionId' => a_string_matching(%r{gid://sagittarius/NodeFunction/\d+}),
          'referencePath' => [a_hash_including('arrayIndex' => 0, 'path' => 'some.path')],
          'parameterIndex' => 1,
          'inputIndex' => 1
        )
      )
      expect(parameter_values).to include(
        a_hash_including(
          '__typename' => 'ReferenceValue',
          'referencePath' => [a_hash_including('arrayIndex' => 1, 'path' => 'some.path')]
        )
      )

      is_expected.to create_audit_event(
        :flow_updated,
        author_id: current_user.id,
        entity_id: flow.id,
        entity_type: 'Flow',
        details: {
          **flow.attributes.except('created_at', 'updated_at'),
        },
        target_id: project.id,
        target_type: 'NamespaceProject'
      )
    end

    context 'when a flow setting value is null' do
      before do
        input[:flowInput][:settings][:value] = nil
      end

      it 'updates the flow setting with a null value' do
        mutate!

        setting_response = graphql_data_at(:namespaces_projects_flows_update, :flow, :settings, :nodes).first
        setting = SagittariusSchema.object_from_id(setting_response['id'])

        expect(setting_response).to include(
          'flowSettingIdentifier' => flow_type.flow_type_settings.first.identifier,
          'value' => nil
        )
        expect(setting.object).to be_nil
      end
    end
  end

  context 'when updating a sub-flow by function identifier' do
    before do
      stub_allowed_ability(NamespaceProjectPolicy, :update_flow, user: current_user, subject: project)
      stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user, subject: project)
    end

    let(:input) do
      {
        flowId: flow.to_global_id.to_s,
        flowInput: {
          name: generate(:flow_name),
          type: flow_type.to_global_id.to_s,
          startingNodeId: flow.starting_node.to_global_id.to_s,
          settings: [],
          nodes: [
            {
              id: flow.starting_node.to_global_id.to_s,
              functionDefinitionId: function_definition.to_global_id.to_s,
              nextNodeId: nil,
              parameters: [
                {
                  value: {
                    subFlowValue: {
                      functionIdentifier: function_definition.identifier,
                      signature: '(input: INPUT): OUTPUT',
                    },
                  },
                }
              ],
            }
          ],
        },
      }
    end

    let(:flow) do
      create(:flow, project: project, flow_type: flow_type).tap do |f|
        node = create(:node_function, flow: f, function_definition: function_definition)
        create(
          :node_parameter,
          node_function: node,
          parameter_definition: function_definition.parameter_definitions.first,
          literal_value: nil
        )
        f.starting_node = node
        f.save!
      end
    end

    it 'stores the referenced function definition on the sub-flow' do
      mutate!

      expect(graphql_data_at(:namespaces_projects_flows_update, :errors)).to be_blank

      parameter_value = graphql_data_at(:namespaces_projects_flows_update, :flow, :nodes, :nodes)
                        .first['parameters']['nodes'].first['value']

      expect(parameter_value).to include(
        '__typename' => 'SubFlowValue',
        'startingNodeId' => nil
      )
      expect(parameter_value['functionDefinition']).to include(
        'id' => function_definition.to_global_id.to_s,
        'identifier' => function_definition.identifier
      )

      sub_flow = flow.reload.starting_node.node_parameters.first.sub_flow
      expect(sub_flow.function_definition).to eq(function_definition)
    end
  end

  context 'when removing nodes' do
    before do
      stub_allowed_ability(NamespaceProjectPolicy, :update_flow, user: current_user, subject: project)
      stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user, subject: project)
    end

    let(:flow) do
      create(:flow, project: project, flow_type: flow_type).tap do |f|
        node1 = create(:node_function, flow: f, function_definition: function_definition)
        node2 = create(:node_function, flow: f, function_definition: function_definition)
        f.starting_node = node1
        node1.next_node = node2
        node1.save!
        f.save!
      end
    end

    let(:input) do
      {
        flowId: flow.to_global_id.to_s,
        flowInput: {
          name: generate(:flow_name),
          type: flow_type.to_global_id.to_s,
          startingNodeId: flow.starting_node.to_global_id.to_s,
          settings: [],
          nodes: [
            {
              id: flow.starting_node.to_global_id.to_s,
              functionDefinitionId: flow.starting_node.function_definition.to_global_id.to_s,
              nextNodeId: nil,
              parameters: [],
            }
          ],
        },
      }
    end

    it 'updates flow by removing all nodes' do
      expect { mutate! }.to change { flow.node_functions.size }.from(2).to(1)

      updated_flow_id = graphql_data_at(:namespaces_projects_flows_update, :flow, :id)
      expect(updated_flow_id).to be_present
      flow = SagittariusSchema.object_from_id(updated_flow_id)

      nodes = graphql_data_at(:namespaces_projects_flows_update, :flow, :nodes, :nodes)
      expect(nodes.size).to eq(1)

      expect(flow).to be_present
      expect(project.flows).to include(flow)
      expect(flow.node_functions.count).to eq(1)
    end
  end

  context 'when removing parameters from a node' do
    before do
      stub_allowed_ability(NamespaceProjectPolicy, :update_flow, user: current_user, subject: project)
      stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user, subject: project)
    end

    let(:flow) do
      create(:flow, project: project, flow_type: flow_type).tap do |f|
        node1 = create(:node_function, flow: f, function_definition: function_definition)
        parameter = create(:node_parameter,
                           node_function: node1,
                           parameter_definition: function_definition.parameter_definitions.first,
                           literal_value: nil)
        node2 = create(:node_function, flow: f, function_definition: function_definition)
        create(:sub_flow, node_parameter: parameter, starting_node: node2, signature: '(input: INPUT): OUTPUT')
        f.starting_node = node1
        node1.save!
        f.save!
      end
    end

    let(:input) do
      {
        flowId: flow.to_global_id.to_s,
        flowInput: {
          name: generate(:flow_name),
          type: flow_type.to_global_id.to_s,
          startingNodeId: flow.starting_node.to_global_id.to_s,
          settings: [],
          nodes: [
            {
              id: flow.starting_node.to_global_id.to_s,
              functionDefinitionId: function_definition.to_global_id.to_s,
              nextNodeId: nil,
              parameters: [],
            },
            {
              id: flow.node_functions.second.to_global_id.to_s,
              functionDefinitionId: function_definition.to_global_id.to_s,
              nextNodeId: nil,
              parameters: [
                {
                  value: {
                    literalValue: 99,
                  },
                }
              ],
            }
          ],
        },
      }
    end

    it 'does not destroy nodes that are still in use' do
      mutate!

      expect(graphql_data_at(:namespaces_projects_flows_update, :errors)).to be_blank
      expect(graphql_data_at(:namespaces_projects_flows_update, :flow)).to be_present
      expect(flow.reload.node_functions.count).to eq(2)
    end
  end

  context 'when clearing sub_flow on a reused node' do
    before do
      stub_allowed_ability(NamespaceProjectPolicy, :update_flow, user: current_user, subject: project)
      stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user, subject: project)
    end

    let(:flow) do
      create(:flow, project: project, flow_type: flow_type).tap do |f|
        node1 = create(:node_function, flow: f, function_definition: function_definition)
        parameter = create(:node_parameter,
                           node_function: node1,
                           parameter_definition: function_definition.parameter_definitions.first,
                           literal_value: nil)
        node2 = create(:node_function, flow: f, function_definition: function_definition)
        create(:sub_flow, node_parameter: parameter, starting_node: node2, signature: '(input: INPUT): OUTPUT')
        f.starting_node = node1
        node1.save!
        f.save!
      end
    end

    let(:input) do
      {
        flowId: flow.to_global_id.to_s,
        flowInput: {
          name: generate(:flow_name),
          type: flow_type.to_global_id.to_s,
          startingNodeId: flow.starting_node.to_global_id.to_s,
          settings: [],
          nodes: [
            {
              id: flow.starting_node.to_global_id.to_s,
              functionDefinitionId: function_definition.to_global_id.to_s,
              nextNodeId: nil,
              parameters: [
                {
                  value: {
                    literalValue: 42,
                  },
                }
              ],
            },
            {
              id: flow.node_functions.second.to_global_id.to_s,
              functionDefinitionId: function_definition.to_global_id.to_s,
              nextNodeId: nil,
              parameters: [
                {
                  value: {
                    literalValue: 99,
                  },
                }
              ],
            }
          ],
        },
      }
    end

    it 'does not destroy nodes that are still in use' do
      mutate!

      expect(graphql_data_at(:namespaces_projects_flows_update, :errors)).to be_blank
      expect(graphql_data_at(:namespaces_projects_flows_update, :flow)).to be_present
      expect(flow.reload.node_functions.count).to eq(2)
    end
  end

  context 'when user does not have the permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_projects_flows_update, :errors)).to be_present
      expect(graphql_data_at(:namespaces_projects_flows_update, :flow)).to be_nil
      expect(graphql_data_at(:namespaces_projects_flows_update, :errors).first['errorCode']).to eq('MISSING_PERMISSION')
    end
  end
end
