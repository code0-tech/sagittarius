# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'teamsCreate Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: TeamsCreateInput!) {
        teamsCreate(input: $input) {
          #{error_query}
          team {
            id
            name
          }
        }
      }
    QUERY
  end

  let(:input) do
    name = generate(:team_name)

    {
      name: name,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  before { post_graphql mutation, variables: variables, current_user: current_user }

  it 'creates team' do
    expect(graphql_data_at(:teams_create, :team, :id)).to be_present

    team = SagittariusSchema.object_from_id(graphql_data_at(:teams_create, :team, :id))

    expect(team.name).to eq(input[:name])

    is_expected.to create_audit_event(
      :team_created,
      author_id: current_user.id,
      entity_id: team.id,
      entity_type: 'Team',
      details: { name: input[:name] },
      target_id: team.id,
      target_type: 'Team'
    )
  end

  context 'when team name is taken' do
    let(:team) { create(:team) }
    let(:input) { { name: team.name } }

    it 'returns an error' do
      expect(graphql_data_at(:teams_create, :team)).to be_nil
      expect(graphql_data_at(:teams_create, :errors)).to include({ 'attribute' => 'name', 'type' => 'taken' })
    end
  end
end
