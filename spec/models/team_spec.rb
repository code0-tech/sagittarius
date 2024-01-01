# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team do
  subject { create(:team) }

  describe 'associations' do
    it { is_expected.to have_many(:team_members).inverse_of(:team) }
    it { is_expected.to have_many(:users).through(:team_members).inverse_of(:teams) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
  end

  describe '#member?' do
    let(:team) { create(:team) }
    let(:user) { create(:user) }

    before { create(:team_member, team: team, user: user) }

    it 'performs a query if members are not loaded' do
      expect { team.member?(user) }.to match_query_count(1)
    end

    it 'performs no query if members are loaded' do
      team.team_members.load

      expect { team.member?(user) }.to match_query_count(0)
    end
  end
end
