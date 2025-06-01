# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesProjectsFlowsDelete Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesProjectsFlowsDeleteInput!) {
        namespacesProjectsFlowsDelete(input: $input) {
          #{error_query}
          flow {
           id
          }
        }
      }
    QUERY
  end

  let(:namespace_project) { create(:namespace_project) }
  let(:starting_node) { create(:node_function) }
  let(:flow_type) { create(:flow_type) }
  let!(:flow) { create(:flow, project: namespace_project, flow_type: flow_type, starting_node: starting_node) }
  let(:input) do
    {
      flowId: flow.to_global_id.to_s,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user has permission' do
    before do
      stub_allowed_ability(NamespaceProjectPolicy, :delete_flows, user: current_user,
                                                                  subject: namespace_project)
      stub_allowed_ability(NamespaceProjectPolicy, :read_flow, user: current_user,
                                                               subject: namespace_project)
    end

    it 'deletes flow' do
      mutate!

      expect(graphql_data_at(:namespaces_projects_flows_delete, :flow, :id)).to be_present

      expect(
        SagittariusSchema.object_from_id(
          graphql_data_at(:namespaces_projects_flows_delete, :flow, :id)
        )
      ).to be_nil

      is_expected.to create_audit_event(
        :flow_deleted,
        author_id: current_user.id,
        entity_id: flow.id,
        entity_type: 'Flow',
        details: {
          **flow.attributes.except('created_at', 'updated_at'),
        },
        target_id: namespace_project.id,
        target_type: 'NamespaceProject'
      )
    end
  end

  context 'when user is not a member of the namespace' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_projects_flows_delete, :flow)).to be_nil
      expect(graphql_data_at(:namespaces_projects_flows_delete,
                             :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
