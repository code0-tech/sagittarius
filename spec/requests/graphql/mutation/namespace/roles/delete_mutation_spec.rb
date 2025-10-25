# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesRolesDelete Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesRolesDeleteInput!) {
        namespacesRolesDelete(input: $input) {
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
  let(:namespace_role) do
    create(:namespace_role, namespace: namespace)
  end
  let(:input) do
    {
      namespaceRoleId: namespace_role.to_global_id.to_s,
    }
  end
  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  before do
    create(:namespace_role, namespace: namespace).tap do |role|
      create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
    end
  end

  context 'when user is a member of the namespace' do
    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespacePolicy, :delete_namespace_role, user: current_user, subject: namespace)
    end

    it 'deletes namespace role' do
      mutate!

      expect(graphql_data_at(:namespaces_roles_delete, :namespace_role, :id)).to be_present

      expect(
        SagittariusSchema.object_from_id(
          graphql_data_at(:namespaces_roles_delete, :namespace_role, :id)
        )
      ).to be_nil

      is_expected.to create_audit_event(
        :namespace_role_deleted,
        author_id: current_user.id,
        entity_id: namespace_role.id,
        entity_type: 'NamespaceRole',
        details: {},
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end

  context 'when user is not a member of the namespace' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_roles_delete, :namespace_role)).to be_nil
      expect(graphql_data_at(:namespaces_roles_delete, :errors)).to include({ 'errorCode' => 'MISSING_PERMISSION' })
    end
  end
end
