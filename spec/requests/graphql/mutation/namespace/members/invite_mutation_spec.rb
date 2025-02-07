# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesMembersInvite Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesMembersInviteInput!) {
        namespacesMembersInvite(input: $input) {
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
  let(:user) { create(:user) }
  let(:input) do
    {
      namespaceId: namespace.to_global_id.to_s,
      userId: user.to_global_id.to_s,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user has permission' do
    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespacePolicy, :invite_member, user: current_user, subject: namespace)
    end

    it 'creates namespace member' do
      mutate!

      expect(graphql_data_at(:namespaces_members_invite, :namespace_member, :id)).to be_present

      namespace_member = SagittariusSchema.object_from_id(
        graphql_data_at(:namespaces_members_invite, :namespace_member, :id)
      )

      expect(namespace_member.user).to eq(user)
      expect(namespace_member.namespace).to eq(namespace)

      is_expected.to create_audit_event(
        :namespace_member_invited,
        author_id: current_user.id,
        entity_id: namespace_member.id,
        entity_type: 'NamespaceMember',
        details: {},
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end

    context 'when target user is already a member' do
      it 'returns an error' do
        create(:namespace_member, namespace: namespace, user: user)

        mutate!

        expect(graphql_data_at(:namespaces_members_invite, :namespace_member)).to be_nil
        expect(
          graphql_data_at(:namespaces_members_invite, :errors)
        ).to include({ 'attribute' => 'namespace', 'type' => 'taken' })
      end
    end
  end

  context 'when user does not have permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_members_invite, :namespace_member)).to be_nil
      expect(graphql_data_at(:namespaces_members_invite, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
