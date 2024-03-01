# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomizablePermission do
  subject { policy_class.new(current_user, team) }

  let(:policy_class) do
    Class.new(BasePolicy) do
      include CustomizablePermission

      team_resolver { |team| team }

      customizable_permission :create_team_role
    end
  end
  let(:current_user) { create(:user) }
  let(:team) { create(:team) }
  let(:team_member) { create(:team_member, team: team, user: current_user) }
  let(:team_role) do
    create(:team_role, team: team).tap { |role| create(:team_member_role, member: team_member, role: role) }
  end

  context 'when user has a role with the ability' do
    before do
      create(:team_role_ability, team_role: team_role, ability: :create_team_role)
    end

    it { is_expected.to be_allowed(:create_team_role) }
  end

  context 'when user has a role with a different ability' do
    before do
      create(:team_role_ability, team_role: team_role, ability: :create_team_role)
    end

    it { is_expected.not_to be_allowed(:invite_member) }
  end

  it { is_expected.not_to be_allowed(:create_team_role) }
end
