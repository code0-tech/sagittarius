# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamPolicy do
  subject { described_class.new(current_user, team) }

  let(:current_user) { nil }

  context 'when user is member of the team' do
    let(:current_user) { create(:user) }
    let(:team) { create(:team).tap { |team| create(:team_member, team: team, user: current_user) } }

    it { is_expected.to be_allowed(:read_team) }
    it { is_expected.to be_allowed(:read_team_member) }
  end

  context 'when user is not member of the team' do
    let(:current_user) { create(:user) }
    let(:team) { create(:team) }

    it { is_expected.not_to be_allowed(:read_team) }
    it { is_expected.not_to be_allowed(:read_team_member) }
  end

  context 'when user is nil' do
    let(:current_user) { nil }
    let(:team) { create(:team) }

    it { is_expected.not_to be_allowed(:read_team) }
    it { is_expected.not_to be_allowed(:read_team_member) }
  end
end
