# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesMembersAssignRoles Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesMembersAssignRolesInput!) {
        namespacesMembersAssignRoles(input: $input) {
          #{error_query}
          namespaceMemberRoles {
            id
            member {
              id
            }
            role {
              id
            }
          }
        }
      }
    QUERY
  end
  let(:namespace) { create(:namespace) }
  let(:namespace_roles) { create_list(:namespace_role, 2, namespace: namespace) }
  let(:member) do
    create(:namespace_member, namespace: namespace).tap do |m|
      create(:namespace_member_role, member: m, role: namespace_roles.last)
    end
  end
  let(:input) do
    {
      memberId: member.to_global_id.to_s,
      roleIds: [namespace_roles.first.to_global_id.to_s],
    }
  end
  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  before do
    create(:namespace_role, namespace: namespace).tap do |role|
      create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
      create(:namespace_member_role, role: role)
    end
  end

  context 'when user has permission' do
    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespacePolicy, :assign_member_roles, user: current_user, subject: namespace)
    end

    it 'assigns the given roles to the member' do
      mutate!

      role_ids = graphql_data_at(:namespaces_members_assign_roles, :namespace_member_roles, :id)
      expect(role_ids).to be_present
      expect(role_ids).to be_a(Array)

      namespace_member_roles = role_ids.map { |id| SagittariusSchema.object_from_id(id) }

      expect(namespace_member_roles.map(&:role)).to eq([namespace_roles.first])

      is_expected.to create_audit_event(
        :namespace_member_roles_updated,
        author_id: current_user.id,
        entity_id: member.id,
        entity_type: 'NamespaceMember',
        details: {
          'new_roles' => [{ 'id' => namespace_roles.first.id, 'name' => namespace_roles.first.name }],
          'old_roles' => [{ 'id' => namespace_roles.last.id, 'name' => namespace_roles.last.name }],
        },
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end

  context 'when user does not have permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_members_assign_roles, :namespace_member_roles)).to be_nil
      expect(
        graphql_data_at(:namespaces_members_assign_roles, :errors, :error_code)
      ).to include('MISSING_PERMISSION')
    end
  end
end
