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
            startingNode {
              id
              parameters {
                nodes {
                  id
                  runtimeParameter {
                    id
                  }
                  value
                }
              }
            }
            settings {
              id
              value
            }
          }
        }
      }
    QUERY
  end

  let(:runtime) { create(:runtime) }
  let(:project) { create(:namespace_project, primary_runtime: runtime) }
  let(:flow_type) { create(:flow_type, runtime: runtime) }
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
      projectId: project.to_global_id.to_s,
      flow: {
        type: flow_type.to_global_id.to_s,
        settings: {
          flowSettingId: 'key',
          object: {
            'key' => 'value',
          },
        },
        startingNode: {
          runtimeFunctionId: runtime_function.to_global_id.to_s,
          parameters: [
            runtimeParameterDefinitionId: runtime_function.parameters.first.to_global_id.to_s,
            value: {
              literalValue: 'test_value',
            }
          ],
        },
      },
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the namespace' do
    before do
      stub_allowed_ability(NamespaceProjectPolicy, :create_flows, user: current_user, subject: project)
      stub_allowed_ability(NamespaceProjectPolicy, :read_flow, user: current_user, subject: project)
    end

    it 'creates namespace project' do
      mutate!

      p parsed_response

      created_flow_id = graphql_data_at(:namespaces_projects_flows_create, :flow, :id)
      expect(created_flow_id).to be_present
      flow = SagittariusSchema.object_from_id(created_flow_id)

      expect(graphql_data_at(:namespaces_projects_flows_create, :flow, :settings).size).to eq(1)

      expect(flow).to be_present
      expect(project.flows).to include(flow)

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
end
