# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespaceProjectsDelete Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespaceProjectsDeleteInput!) {
        namespaceProjectsDelete(input: $input) {
          #{error_query}
          namespaceProject {
            id
            namespace {
              id
            }
          }
        }
      }
    QUERY
  end

  let(:namespace) { create(:namespace) }
  let(:namespace_project) { create(:namespace_project, namespace: namespace) }
  let(:input) do
    {
      namespaceProjectId: namespace_project.to_global_id.to_s,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the namespace' do
    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespaceProjectPolicy, :delete_namespace_project, user: current_user,
                                                                              subject: namespace_project)
      stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user,
                                                                            subject: namespace_project)
    end

    it 'deletes namespace project' do
      mutate!

      expect(graphql_data_at(:namespace_projects_delete, :namespace_project, :id)).to be_present

      expect(
        SagittariusSchema.object_from_id(
          graphql_data_at(:namespace_projects_delete, :namespace_project, :id)
        )
      ).to be_nil

      is_expected.to create_audit_event(
        :namespace_project_deleted,
        author_id: current_user.id,
        entity_id: namespace_project.id,
        entity_type: 'NamespaceProject',
        details: {},
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end

  context 'when user is not a member of the namespace' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespace_projects_delete, :namespace_project)).to be_nil
      expect(graphql_data_at(:namespace_projects_delete, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
