# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'teamRolesAssignAbilities Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: TeamRolesAssignAbilitiesInput!) {
        teamRolesAssignAbilities(input: $input) {
          #{error_query}
          abilities
        }
      }
    QUERY
  end

  let(:team_role) { create(:team_role) }
  let(:input) do
    {
      roleId: team_role.to_global_id.to_s,
      abilities: ['CREATE_TEAM_ROLE'],
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user has permission' do
    before do
      stub_allowed_ability(TeamPolicy, :assign_role_abilities, user: current_user, subject: team_role.team)
    end

    it 'assigns the given abilities to the role' do
      mutate!

      abilities = graphql_data_at(:team_roles_assign_abilities, :abilities)
      expect(abilities).to be_present
      expect(abilities).to be_a(Array)

      expect(abilities).to eq(['CREATE_TEAM_ROLE'])

      is_expected.to create_audit_event(
        :team_role_abilities_updated,
        author_id: current_user.id,
        entity_id: team_role.id,
        entity_type: 'TeamRole',
        details: {
          'new_abilities' => ['create_team_role'],
          'old_abilities' => [],
        },
        target_id: team_role.team.id,
        target_type: 'Team'
      )
    end
  end

  context 'when user does not have permission' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:team_roles_assign_abilities, :abilities)).to be_nil
      expect(graphql_data_at(:team_roles_assign_abilities, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
