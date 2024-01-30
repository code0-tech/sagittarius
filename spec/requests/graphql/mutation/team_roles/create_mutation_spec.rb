# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'teamRolesCreate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: TeamRolesCreateInput!) {
        teamRolesCreate(input: $input) {
          #{error_query}
          teamRole {
            id
            name
            team {
              id
            }
          }
        }
      }
    QUERY
  end

  let(:team) { create(:team) }
  let(:input) do
    name = generate(:role_name)

    {
      teamId: team.to_global_id.to_s,
      name: name,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the team' do
    before do
      create(:team_member, team: team, user: current_user)
      stub_allowed_ability(TeamPolicy, :create_team_role, user: current_user, subject: team)
      stub_allowed_ability(TeamPolicy, :read_team_role, user: current_user, subject: team)
    end

    it 'creates team role' do
      mutate!

      expect(graphql_data_at(:team_roles_create, :team_role, :id)).to be_present

      team_role = SagittariusSchema.object_from_id(graphql_data_at(:team_roles_create, :team_role, :id))

      expect(team_role.name).to eq(input[:name])
      expect(team_role.team).to eq(team)

      is_expected.to create_audit_event(
        :team_role_created,
        author_id: current_user.id,
        entity_id: team_role.id,
        entity_type: 'TeamRole',
        details: { name: input[:name] },
        target_id: team.id,
        target_type: 'Team'
      )
    end

    context 'when team role name is taken' do
      let(:team_role) { create(:team_role, team: team) }
      let(:input) { { teamId: team.to_global_id.to_s, name: team_role.name } }

      it 'returns an error' do
        mutate!

        expect(graphql_data_at(:team_roles_create, :team_role)).to be_nil
        expect(graphql_data_at(:team_roles_create, :errors)).to include({ 'attribute' => 'name', 'type' => 'taken' })
      end
    end

    context 'when team role name is taken in another team' do
      let(:other_team) { create(:team).tap { |t| create(:team_role, team: t, name: input[:name]) } }

      it 'creates team role' do
        mutate!

        expect(graphql_data_at(:team_roles_create, :team_role, :id)).to be_present

        team_role = SagittariusSchema.object_from_id(graphql_data_at(:team_roles_create, :team_role, :id))

        expect(team_role.name).to eq(input[:name])
        expect(team_role.team).to eq(team)

        is_expected.to create_audit_event(
          :team_role_created,
          author_id: current_user.id,
          entity_id: team_role.id,
          entity_type: 'TeamRole',
          details: { name: input[:name] },
          target_id: team.id,
          target_type: 'Team'
        )
      end
    end
  end

  context 'when user is not a member of the team' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:team_roles_create, :team_role)).to be_nil
      expect(graphql_data_at(:team_roles_create, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
