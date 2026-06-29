# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesMembersBulkInvite Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesMembersBulkInviteInput!) {
        namespacesMembersBulkInvite(input: $input) {
          #{error_query}
          namespaceMembers {
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
  let(:users) { create_list(:user, 2) }
  let(:input) do
    {
      namespaceId: namespace.to_global_id.to_s,
      userIds: users.map { |user| user.to_global_id.to_s },
    }
  end
  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user has permission' do
    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespacePolicy, :invite_member, user: current_user, subject: namespace)
    end

    it 'creates all namespace members and their audit events' do
      mutate!

      member_ids = graphql_data_at(:namespaces_members_bulk_invite, :namespace_members, :id)
      namespace_members = member_ids.map { |id| SagittariusSchema.object_from_id(id) }

      expect(namespace_members.map(&:user)).to match_array(users)
      expect(namespace_members.map(&:namespace)).to all(eq(namespace))
      expect(
        AuditEvent.where(
          action_type: :namespace_member_invited,
          entity_type: 'NamespaceMember',
          entity_id: namespace_members.map(&:id)
        ).count
      ).to eq(2)
    end

    it 'rolls back all invitations when one user is already a member' do
      create(:namespace_member, namespace: namespace, user: users.last)

      expect { mutate! }.not_to change { namespace.namespace_members.count }

      expect(graphql_data_at(:namespaces_members_bulk_invite, :namespace_members)).to be_nil
      expect(
        graphql_data_at(:namespaces_members_bulk_invite, :errors, :details)
      ).to include([{ 'attribute' => 'namespace', 'type' => 'taken' }])
    end
  end

  context 'when user does not have permission' do
    it 'returns an error without creating members' do
      expect { mutate! }.not_to change { NamespaceMember.count }

      expect(graphql_data_at(:namespaces_members_bulk_invite, :namespace_members)).to be_nil
      expect(
        graphql_data_at(:namespaces_members_bulk_invite, :errors, :error_code)
      ).to include('MISSING_PERMISSION')
    end
  end
end
