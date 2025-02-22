# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesProjectsUpdate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesProjectsUpdateInput!) {
        namespacesProjectsUpdate(input: $input) {
          #{error_query}
          namespaceProject {
            name
            description
            id
          }
        }
      }
    QUERY
  end

  let(:namespace_project) { create(:namespace_project) }
  let(:input) do
    name = generate(:namespace_project_name)
    description = "Description for #{name}"

    {
      namespaceProjectId: namespace_project.to_global_id.to_s,
      name: name,
      description: description,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the namespace' do
    before do
      create(:namespace_member, namespace: namespace_project.namespace, user: current_user)
      stub_allowed_ability(NamespaceProjectPolicy, :update_namespace_project, user: current_user,
                                                                              subject: namespace_project)
      stub_allowed_ability(NamespaceProjectPolicy, :read_namespace_project, user: current_user,
                                                                            subject: namespace_project)
    end

    it 'updates namespace project' do
      mutate!

      expect(graphql_data_at(:namespaces_projects_update, :namespace_project, :id)).to be_present

      project = SagittariusSchema.object_from_id(
        graphql_data_at(:namespaces_projects_update, :namespace_project, :id)
      )

      expect(project.name).to eq(input[:name])
      expect(project.description).to eq(input[:description])

      is_expected.to create_audit_event(
        :namespace_project_updated,
        author_id: current_user.id,
        entity_id: project.id,
        entity_type: 'NamespaceProject',
        details: { name: input[:name], description: input[:description] },
        target_id: project.id,
        target_type: 'NamespaceProject'
      )
    end

    context 'when namespace project name is taken' do
      let(:existing_namespace_project) do
        create(:namespace_project, namespace: namespace_project.namespace)
      end

      let(:input) do
        { namespaceProjectId: namespace_project.to_global_id.to_s, name: existing_namespace_project.name }
      end

      it 'returns an error' do
        mutate!

        expect(graphql_data_at(:namespaces_projects_update, :namespace_project)).to be_nil
        expect(
          graphql_data_at(:namespaces_projects_update, :errors)
        ).to include({ 'attribute' => 'name', 'type' => 'taken' })
      end
    end

    context 'when namespace project name is taken in another namespace' do
      before do
        create(:namespace).tap { |n| create(:namespace_project, namespace: n, name: input[:name]) }
      end

      it 'updates namespace project' do
        mutate!

        expect(graphql_data_at(:namespaces_projects_update, :namespace_project, :id)).to be_present

        project = SagittariusSchema.object_from_id(
          graphql_data_at(:namespaces_projects_update, :namespace_project, :id)
        )

        expect(project.name).to eq(input[:name])
        expect(project.description).to eq(input[:description])

        is_expected.to create_audit_event(
          :namespace_project_updated,
          author_id: current_user.id,
          entity_id: project.id,
          entity_type: 'NamespaceProject',
          details: { name: input[:name], description: input[:description] },
          target_id: project.id,
          target_type: 'NamespaceProject'
        )
      end
    end
  end

  context 'when user is not a member of the namespace' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_projects_update, :namespace_project)).to be_nil
      expect(graphql_data_at(:namespaces_projects_update, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
