# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'teamMembersInvite Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: TeamMembersInviteInput!) {
        teamMembersInvite(input: $input) {
          #{error_query}
          teamMember {
            id
            user {
              id
            }
            team {
              id
            }
          }
        }
      }
    QUERY
  end

  let(:team) { create(:team) }
  let(:user) { create(:user) }
  let(:input) do
    {
      teamId: team.to_global_id.to_s,
      userId: user.to_global_id.to_s,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user has permission' do
    before do
      create(:team_member, team: team, user: current_user)
      stub_allowed_ability(TeamPolicy, :invite_member, user: current_user, subject: team)
    end

    it 'creates team member' do
      mutate!

      expect(graphql_data_at(:team_members_invite, :team_member, :id)).to be_present

      team_member = SagittariusSchema.object_from_id(graphql_data_at(:team_members_invite, :team_member, :id))

      expect(team_member.user).to eq(user)
      expect(team_member.team).to eq(team)

      is_expected.to create_audit_event(
        :team_member_invited,
        author_id: current_user.id,
        entity_id: team_member.id,
        entity_type: 'TeamMember',
        details: {},
        target_id: team.id,
        target_type: 'Team'
      )
    end

    context 'when target user is already a member' do
      it 'returns an error' do
        create(:team_member, team: team, user: user)

        mutate!

        expect(graphql_data_at(:team_members_invite, :team_member)).to be_nil
        expect(graphql_data_at(:team_members_invite, :errors)).to include({ 'attribute' => 'team', 'type' => 'taken' })
      end
    end
  end

  context 'when user does not have permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:team_members_invite, :team_member)).to be_nil
      expect(graphql_data_at(:team_members_invite, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
