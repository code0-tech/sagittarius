# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesRolesCreate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesRolesCreateInput!) {
        namespacesRolesCreate(input: $input) {
          #{error_query}
          namespaceRole {
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
    name = generate(:role_name)

    {
      namespaceId: namespace.to_global_id.to_s,
      name: name,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the namespace' do
    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespacePolicy, :create_namespace_role, user: current_user, subject: namespace)
    end

    it 'creates namespace role' do
      mutate!

      expect(graphql_data_at(:namespaces_roles_create, :namespace_role, :id)).to be_present

      namespace_role = SagittariusSchema.object_from_id(
        graphql_data_at(:namespaces_roles_create, :namespace_role, :id)
      )

      expect(namespace_role.name).to eq(input[:name])
      expect(namespace_role.namespace).to eq(namespace)

      is_expected.to create_audit_event(
        :namespace_role_created,
        author_id: current_user.id,
        entity_id: namespace_role.id,
        entity_type: 'NamespaceRole',
        details: { name: input[:name] },
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end

    context 'when namespace role name is taken' do
      let(:namespace_role) { create(:namespace_role, namespace: namespace) }
      let(:input) { { namespaceId: namespace.to_global_id.to_s, name: namespace_role.name } }

      it 'returns an error' do
        mutate!

        expect(graphql_data_at(:namespaces_roles_create, :namespace_role)).to be_nil
        expect(
          graphql_data_at(:namespaces_roles_create, :errors, :details)
        ).to include([{ 'attribute' => 'name', 'type' => 'taken' }])
      end
    end

    context 'when namespace role name is taken in another namespace' do
      before do
        create(:namespace).tap { |n| create(:namespace_role, namespace: n, name: input[:name]) }
      end

      it 'creates namespace role' do
        mutate!

        expect(graphql_data_at(:namespaces_roles_create, :namespace_role, :id)).to be_present

        namespace_role = SagittariusSchema.object_from_id(
          graphql_data_at(:namespaces_roles_create, :namespace_role, :id)
        )

        expect(namespace_role.name).to eq(input[:name])
        expect(namespace_role.namespace).to eq(namespace)

        is_expected.to create_audit_event(
          :namespace_role_created,
          author_id: current_user.id,
          entity_id: namespace_role.id,
          entity_type: 'NamespaceRole',
          details: { name: input[:name] },
          target_id: namespace.id,
          target_type: 'Namespace'
        )
      end
    end
  end

  context 'when user is not a member of the namespace' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_roles_create, :namespace_role)).to be_nil
      expect(graphql_data_at(:namespaces_roles_create, :errors, :error_code)).to include('MISSING_PERMISSION')
    end
  end
end
