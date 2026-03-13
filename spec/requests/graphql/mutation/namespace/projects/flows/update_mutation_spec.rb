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
  let(:flow_type) { create(:flow_type, runtime: runtime) }
  let(:flow) { create(:flow, project: project, flow_type: flow_type) }
  let(:function_definition) do
    rfd = create(:runtime_function_definition, runtime: runtime)
    rpd = create(
      :runtime_parameter_definition,
      runtime_function_definition: rfd,
      data_type: create(
        :data_type_identifier,
        runtime: runtime,
        data_type: create(:data_type, runtime: runtime)
      )
    )

    create(:function_definition, runtime_function_definition: rfd).tap do |fd|
      create(
        :parameter_definition,
        runtime_parameter_definition: rpd,
        function_definition: fd,
        data_type: rpd.data_type
      )
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
          flowSettingIdentifier: 'key',
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
                parameterDefinitionId: function_definition.parameter_definitions.first.to_global_id.to_s,
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
              parameterDefinitionId: function_definition.parameter_definitions.first.to_global_id.to_s,
              value: {
                nodeFunctionId: 'gid://sagittarius/NodeFunction/2000',
              }
            ],
            nextNodeId: 'gid://sagittarius/NodeFunction/1001',
          },
          {
            id: 'gid://sagittarius/NodeFunction/1001',
            functionDefinitionId: function_definition.to_global_id.to_s,
            parameters: [
              {
                parameterDefinitionId: function_definition.parameter_definitions.first.to_global_id.to_s,
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
                parameterDefinitionId: function_definition.parameter_definitions.first.to_global_id.to_s,
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

      expect(graphql_data_at(:namespaces_projects_flows_update, :flow, :settings).size).to eq(1)

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

    context 'when flow is disabled' do
      let(:input) do
        {
          flowId: flow.to_global_id.to_s,
          flowInput: {
            name: generate(:flow_name),
            disabledReason: 'Some reason',
            type: flow_type.to_global_id.to_s,
            startingNodeId: nil,
            settings: [],
            nodes: [],
          },
        }
      end

      it 'updates flow as disabled' do
        mutate!

        updated_flow_id = graphql_data_at(:namespaces_projects_flows_update, :flow, :id)
        expect(updated_flow_id).to be_present
        flow = SagittariusSchema.object_from_id(updated_flow_id)

        expect(flow).to be_present
        expect(project.flows).to include(flow)
        expect(flow.disabled_reason).to eq('Some reason')
      end
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

  context 'when user does not have the permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_projects_flows_update, :errors)).to be_present
      expect(graphql_data_at(:namespaces_projects_flows_update, :flow)).to be_nil
      expect(graphql_data_at(:namespaces_projects_flows_update, :errors).first['errorCode']).to eq('MISSING_PERMISSION')
    end
  end
end
