# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesMembersDelete Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let!(:admin_role) do
    create(:namespace_role, namespace: namespace).tap do |role|
      create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
      create(:namespace_member_role, role: role)
    end
  end
  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesMembersDeleteInput!) {
        namespacesMembersDelete(input: $input) {
          #{error_query}
          namespaceMember {
            id
            user {
              id
            }
            namespace {
              id
            }
          }
        }
      }
    QUERY
  end
  let(:namespace) { create(:namespace) }
  let(:namespace_member) { create(:namespace_member, namespace: namespace) }
  let(:input) do
    {
      namespaceMemberId: namespace_member.to_global_id.to_s,
    }
  end
  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  before do
    create(:namespace_member, namespace: namespace).tap do |member|
      create(:namespace_member_role, member: member, role: admin_role)
    end
  end

  context 'when user has permission' do
    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespacePolicy, :delete_member, user: current_user, subject: namespace)
    end

    it 'deletes namespace member' do
      mutate!

      expect(graphql_data_at(:namespaces_members_delete, :namespace_member, :id)).to be_present

      expect(
        SagittariusSchema.object_from_id(
          graphql_data_at(:namespaces_members_delete, :namespace_member, :id)
        )
      ).to be_nil

      is_expected.to create_audit_event(
        :namespace_member_deleted,
        author_id: current_user.id,
        entity_id: namespace_member.id,
        entity_type: 'NamespaceMember',
        details: {},
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end

  context 'when user does not have permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_members_delete, :namespace_member)).to be_nil
      expect(graphql_data_at(:namespaces_members_delete, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
