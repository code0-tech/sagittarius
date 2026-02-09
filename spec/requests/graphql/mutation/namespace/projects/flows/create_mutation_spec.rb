# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesProjectsFlowsCreate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesProjectsFlowsCreateInput!) {
        namespacesProjectsFlowsCreate(input: $input) {
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
  let(:function_definition) do
    rfd = create(:runtime_function_definition, runtime: runtime)
    rpd = create(
      :runtime_parameter_definition,
      runtime_function_definition: rfd,
      data_type: create(
        :data_type_identifier,
        data_type: create(:data_type)
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
      projectId: project.to_global_id.to_s,
      flow: {
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
      namespace_role = create(:namespace_role, namespace: project.namespace).tap do |role|
        create(:namespace_role_ability, namespace_role: role, ability: :create_flow)
        create(:namespace_role_ability, namespace_role: role, ability: :read_namespace_project)
      end
      namespace_member = create(:namespace_member, namespace: project.namespace, user: current_user)
      create(:namespace_member_role, role: namespace_role, member: namespace_member)
    end

    context 'when flow name is taken' do
      before do
        create(:flow, name: input[:flow][:name], project: project)
      end

      it 'returns an error' do
        mutate!

        expect(graphql_data_at(:namespaces_projects_flows_create, :errors)).to be_present
        expect(graphql_data_at(:namespaces_projects_flows_create, :flow)).to be_nil
        expect(graphql_data_at(:namespaces_projects_flows_create, :errors,
                               :error_code)).to contain_exactly('INVALID_FLOW')
      end
    end

    it 'creates flow' do
      mutate!

      created_flow_id = graphql_data_at(:namespaces_projects_flows_create, :flow, :id)
      expect(created_flow_id).to be_present
      flow = SagittariusSchema.object_from_id(created_flow_id)

      expect(graphql_data_at(:namespaces_projects_flows_create, :flow, :settings).size).to eq(1)

      nodes = graphql_data_at(:namespaces_projects_flows_create, :flow, :nodes, :nodes)
      starting_node = nodes.find do |n|
        n['id'] == graphql_data_at(:namespaces_projects_flows_create, :flow, :starting_node_id)
      end
      expect(starting_node['parameters']['count']).to eq(1)

      expect(flow).to be_present
      expect(project.flows).to include(flow)
      expect(flow.node_functions.count).to eq(3)

      parameter_values = graphql_data_at(
        :namespaces_projects_flows_create,
        :flow,
        :nodes,
        :nodes,
        :parameters,
        :nodes,
        :value
      )
      expect(parameter_values).to include(a_hash_including('value' => 100))
      expect(parameter_values).to include(
        a_hash_including('referencePath' => [a_hash_including('arrayIndex' => 0, 'path' => 'some.path')])
      )

      is_expected.to create_audit_event(
        :flow_created,
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

  context 'when user does not have the permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_projects_flows_create, :errors)).to be_present
      expect(graphql_data_at(:namespaces_projects_flows_create, :flow)).to be_nil
      expect(graphql_data_at(:namespaces_projects_flows_create, :errors).first['errorCode']).to eq('MISSING_PERMISSION')
    end
  end
end
