# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationMembersDelete Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let!(:admin_role) do
    create(:organization_role, organization: organization).tap do |role|
      create(:organization_role_ability, organization_role: role, ability: :organization_administrator)
      create(:organization_member_role, role: role)
    end
  end
  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationMembersDeleteInput!) {
        organizationMembersDelete(input: $input) {
          #{error_query}
          organizationMember {
            id
            user {
              id
            }
            organization {
              id
            }
          }
        }
      }
    QUERY
  end
  let(:organization) { create(:organization) }
  let(:organization_member) { create(:organization_member, organization: organization) }
  let(:input) do
    {
      organizationMemberId: organization_member.to_global_id.to_s,
    }
  end
  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  before do
    create(:organization_member, organization: organization).tap do |member|
      create(:organization_member_role, member: member, role: admin_role)
    end
  end

  context 'when user has permission' do
    before do
      create(:organization_member, organization: organization, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :delete_member, user: current_user, subject: organization)
    end

    it 'deletes organization member' do
      mutate!

      expect(graphql_data_at(:organization_members_delete, :organization_member, :id)).to be_present

      expect(
        SagittariusSchema.object_from_id(
          graphql_data_at(:organization_members_delete, :organization_member, :id)
        )
      ).to be_nil

      is_expected.to create_audit_event(
        :organization_member_deleted,
        author_id: current_user.id,
        entity_id: organization_member.id,
        entity_type: 'OrganizationMember',
        details: {},
        target_id: organization.id,
        target_type: 'Organization'
      )
    end
  end

  context 'when user does not have permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:organization_members_delete, :organization_member)).to be_nil
      expect(graphql_data_at(:organization_members_delete, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
