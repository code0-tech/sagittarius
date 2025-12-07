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
  let(:runtime_function) do
    create(:runtime_function_definition, runtime: runtime,
                                         parameters: [

                                           create(:runtime_parameter_definition,
                                                  data_type: create(:data_type_identifier,
                                                                    data_type: create(:data_type)))

                                         ])
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
          { id: 'gid://sagittarius/NodeFunction/2000',
            runtimeFunctionId: runtime_function.to_global_id.to_s,
            nextNodeId: nil,
            parameters: [
              {
                runtimeParameterDefinitionId: runtime_function.parameters.first.to_global_id.to_s,
                value: {
                  literalValue: 100,
                },
              }
            ] },
          {
            id: 'gid://sagittarius/NodeFunction/1000',
            runtimeFunctionId: runtime_function.to_global_id.to_s,
            parameters: [
              runtimeParameterDefinitionId: runtime_function.parameters.first.to_global_id.to_s,
              value: {
                nodeFunctionId: 'gid://sagittarius/NodeFunction/2000',
              }
            ],
            nextNodeId: 'gid://sagittarius/NodeFunction/1001',
          },
          {
            id: 'gid://sagittarius/NodeFunction/1001',
            runtimeFunctionId: runtime_function.to_global_id.to_s,
            parameters: [
              runtimeParameterDefinitionId: runtime_function.parameters.first.to_global_id.to_s,
              value: {
                referenceValue: {
                  depth: 1,
                  node: 1,
                  scope: [],
                  referencePath: [],
                  nodeFunctionId: 'gid://sagittarius/NodeFunction/2000',
                  dataTypeIdentifier: {
                    genericKey: 'K',
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
      expect(flow.collect_node_functions.count).to eq(2)

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
  end

  context 'when removing nodes' do
    before do
      stub_allowed_ability(NamespaceProjectPolicy, :update_flow, user: current_user, subject: project)
      stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user, subject: project)
    end

    let(:flow) do
      create(:flow, project: project, flow_type: flow_type).tap do |f|
        node1 = create(:node_function, flow: f, runtime_function: runtime_function)
        node2 = create(:node_function, flow: f, runtime_function: runtime_function)
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
              runtimeFunctionId: flow.starting_node.runtime_function.to_global_id.to_s,
              nextNodeId: nil,
              parameters: [],
            }
          ],
        },
      }
    end

    it 'updates flow by removing all nodes' do
      expect { mutate! }.to change { flow.collect_node_functions.size }.from(2).to(1)

      updated_flow_id = graphql_data_at(:namespaces_projects_flows_update, :flow, :id)
      expect(updated_flow_id).to be_present
      flow = SagittariusSchema.object_from_id(updated_flow_id)

      nodes = graphql_data_at(:namespaces_projects_flows_update, :flow, :nodes, :nodes)
      expect(nodes.size).to eq(1)

      expect(flow).to be_present
      expect(project.flows).to include(flow)
      expect(flow.collect_node_functions.count).to eq(1)
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
