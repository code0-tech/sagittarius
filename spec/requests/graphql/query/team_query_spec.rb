# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'team Query' do
  include GraphqlHelpers

  let(:query) do
    <<~QUERY
      query($teamId: TeamID!) {
        team(id: $teamId) {
          id
          name
        }
      }
    QUERY
  end

  let(:current_user) { nil }
  let(:team_id) { nil }
  let(:variables) { { teamId: team_id } }

  before { post_graphql query, variables: variables, current_user: current_user }

  context 'without an id' do
    it 'returns an error' do
      expect(graphql_data_at(:graphql)).to be_nil
      expect(graphql_errors).not_to be_empty
    end
  end

  context 'with an invalid id' do
    let(:team_id) { 'gid://sagittarius/Teams/1' }

    it 'returns an error' do
      expect(graphql_data_at(:team)).to be_nil
      expect(graphql_errors).not_to be_empty
    end
  end

  context 'with a valid id but out of range' do
    let(:team_id) { 'gid://sagittarius/Team/0' }

    it 'returns only nil' do
      expect(graphql_data_at(:team)).to be_nil
      expect_graphql_errors_to_be_empty
    end
  end

  context 'with a valid id' do
    let(:team) { create(:team) }
    let(:team_id) { "gid://sagittarius/Team/#{team.id}" }

    context 'when user is a member' do
      let(:current_user) do
        create(:user).tap do |user|
          create(:team_member, team: team, user: user)
        end
      end

      it 'returns the team' do
        expect(graphql_data_at(:team, :id)).to eq(team.to_global_id.to_s)
        expect(graphql_data_at(:team, :name)).to eq(team.name)
      end
    end

    context 'when user is not a member' do
      let(:current_user) { create(:user) }

      it 'returns only nil' do
        expect(graphql_data_at(:team)).to be_nil
        expect_graphql_errors_to_be_empty
      end
    end

    context 'when user is anonymous' do
      it 'returns only nil' do
        expect(graphql_data_at(:team)).to be_nil
        expect_graphql_errors_to_be_empty
      end
    end
  end
end
