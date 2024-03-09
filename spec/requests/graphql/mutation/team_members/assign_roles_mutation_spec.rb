# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'teamMembersAssignRoles Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: TeamMembersAssignRolesInput!) {
        teamMembersAssignRoles(input: $input) {
          #{error_query}
          organizationMemberRoles {
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

  let(:team) { create(:team) }
  let(:team_roles) { create_list(:team_role, 2, team: team) }
  let(:member) do
    create(:team_member, team: team).tap do |m|
      create(:organization_member_role, member: m, role: team_roles.last)
    end
  end
  let(:input) do
    {
      memberId: member.to_global_id.to_s,
      roleIds: [team_roles.first.to_global_id.to_s],
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user has permission' do
    before do
      create(:team_member, team: team, user: current_user)
      stub_allowed_ability(TeamPolicy, :assign_member_roles, user: current_user, subject: team)
    end

    it 'assigns the given roles to the member' do
      mutate!

      role_ids = graphql_data_at(:team_members_assign_roles, :organization_member_roles, :id)
      expect(role_ids).to be_present
      expect(role_ids).to be_a(Array)

      organization_member_roles = role_ids.map { |id| SagittariusSchema.object_from_id(id) }

      expect(organization_member_roles.map(&:role)).to eq([team_roles.first])

      is_expected.to create_audit_event(
        :organization_member_roles_updated,
        author_id: current_user.id,
        entity_id: member.id,
        entity_type: 'TeamMember',
        details: {
          'new_roles' => [{ 'id' => team_roles.first.id, 'name' => team_roles.first.name }],
          'old_roles' => [{ 'id' => team_roles.last.id, 'name' => team_roles.last.name }],
        },
        target_id: team.id,
        target_type: 'Team'
      )
    end
  end

  context 'when user does not have permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:team_members_assign_roles, :organization_member_roles)).to be_nil
      expect(graphql_data_at(:team_members_assign_roles, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
