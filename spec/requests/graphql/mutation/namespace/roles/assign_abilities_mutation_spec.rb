# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesRolesAssignAbilities Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesRolesAssignAbilitiesInput!) {
        namespacesRolesAssignAbilities(input: $input) {
          #{error_query}
          abilities
        }
      }
    QUERY
  end
  let(:namespace_role) { create(:namespace_role) }
  let(:input) do
    {
      roleId: namespace_role.to_global_id.to_s,
      abilities: ['CREATE_NAMESPACE_ROLE'],
    }
  end
  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  before do
    create(:namespace_role, namespace: namespace_role.namespace).tap do |role|
      create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
    end
  end

  context 'when user has permission' do
    before do
      stub_allowed_ability(
        NamespacePolicy,
        :assign_role_abilities,
        user: current_user,
        subject: namespace_role.namespace
      )
    end

    it 'assigns the given abilities to the role' do
      mutate!

      abilities = graphql_data_at(:namespaces_roles_assign_abilities, :abilities)
      expect(abilities).to be_present
      expect(abilities).to be_a(Array)

      expect(abilities).to eq(['CREATE_NAMESPACE_ROLE'])

      is_expected.to create_audit_event(
        :namespace_role_abilities_updated,
        author_id: current_user.id,
        entity_id: namespace_role.id,
        entity_type: 'NamespaceRole',
        details: {
          'new_abilities' => ['create_namespace_role'],
          'old_abilities' => [],
        },
        target_id: namespace_role.namespace.id,
        target_type: 'Namespace'
      )
    end
  end

  context 'when user does not have permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_roles_assign_abilities, :abilities)).to be_nil
      expect(
        graphql_data_at(:namespaces_roles_assign_abilities, :errors, :error_code)
      ).to include('MISSING_PERMISSION')
    end
  end
end
