# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Team'] do
  let(:fields) do
    %w[
      id
      name
      members
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('Team') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_team) }

  context 'when requesting members' do
    it_behaves_like 'prevents N+1 queries (graphql)' do
      let(:query) do
        <<~QUERY
          query($teamId: TeamID) {
            team(id: $teamId) {
              members {
                count
                nodes {
                  id
                  user { username }
                  team { name }
                }
              }
            }
          }
        QUERY
      end

      let(:current_user) { create(:user) }
      let(:team) { create(:team).tap { |team| create(:team_member, team: team, user: current_user) } }
      let(:variables) { { teamId: team.to_global_id.to_s } }

      let(:create_new_record) do
        -> { create(:team_member, team: team) }
      end
    end
  end
end
