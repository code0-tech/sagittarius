# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesProjectsCreate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesProjectsCreateInput!) {
        namespacesProjectsCreate(input: $input) {
          #{error_query}
          namespaceProject {
            id
            name
            namespace {
              id
            }
          }
        }
      }
    QUERY
  end

  let(:namespace) { create(:namespace) }
  let(:input) do
    name = generate(:namespace_project_name)

    {
      namespaceId: namespace.to_global_id.to_s,
      name: name,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  before do
    create(:namespace_member, namespace: namespace, user: current_user)
  end

  context 'when user is a member of the namespace' do
    before do
      stub_allowed_ability(NamespacePolicy, :create_namespace_project, user: current_user, subject: namespace)
    end

    it 'creates namespace project' do
      mutate!

      created_project_id = graphql_data_at(:namespaces_projects_create, :namespace_project, :id)
      expect(created_project_id).to be_present
      namespace_project = SagittariusSchema.object_from_id(created_project_id)

      expect(namespace_project.name).to eq(input[:name])
      expect(namespace_project.namespace).to eq(namespace)

      is_expected.to create_audit_event(
        :namespace_project_created,
        author_id: current_user.id,
        entity_id: namespace_project.id,
        entity_type: 'NamespaceProject',
        details: { name: input[:name], slug: namespace_project.slug },
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end

    context 'when namespace project name is taken' do
      let(:namespace_project) { create(:namespace_project, namespace: namespace) }
      let(:input) { { namespaceId: namespace.to_global_id.to_s, name: namespace_project.name } }

      it 'returns an error' do
        mutate!

        expect(graphql_data_at(:namespaces_projects_create, :namespace_project)).to be_nil
        expect(
          graphql_data_at(:namespaces_projects_create, :errors, :details)
        ).to include([{ 'attribute' => 'name', 'type' => 'taken' }])
      end
    end

    context 'when namespace project name is taken in another namespace' do
      before do
        create(:namespace_project, name: input[:name])
        stub_allowed_ability(NamespacePolicy, :create_namespace_project, user: current_user,
                                                                         subject: namespace)
      end

      it 'creates namespace project' do
        mutate!

        created_project_id = graphql_data_at(:namespaces_projects_create, :namespace_project, :id)
        expect(created_project_id).to be_present
        namespace_project = SagittariusSchema.object_from_id(created_project_id)

        expect(namespace_project.name).to eq(input[:name])
        expect(namespace_project.description).to eq('')
        expect(namespace_project.namespace).to eq(namespace)

        is_expected.to create_audit_event(
          :namespace_project_created,
          author_id: current_user.id,
          entity_id: namespace_project.id,
          entity_type: 'NamespaceProject',
          details: { name: input[:name], slug: namespace_project.slug },
          target_id: namespace.id,
          target_type: 'Namespace'
        )
      end
    end
  end

  context 'when user is not a member of the namespace' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_projects_create, :namespace_project)).to be_nil
      expect(graphql_data_at(:namespaces_projects_create, :errors, :error_code)).to include('MISSING_PERMISSION')
    end
  end
end
