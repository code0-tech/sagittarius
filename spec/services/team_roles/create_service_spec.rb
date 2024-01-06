# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamRoles::CreateService do
  subject(:service_response) { described_class.new(current_user, team, params).execute }

  let(:team) { create(:team) }
  let(:role_name) { generate(:role_name) }
  let(:params) { { name: role_name } }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { TeamRole.count } }

    it do
      expect { service_response }.not_to create_audit_event(:team_role_created)
    end
  end

  context 'when user is not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { TeamRole.count } }

    it do
      expect { service_response }.not_to create_audit_event(:team_role_created)
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      create(:team_member, team: team, user: current_user)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.team).to eq(team) }
    it { expect(service_response.payload.name).to eq(role_name) }
    it { expect { service_response }.to change { TeamRole.count }.by(1) }

    it do
      expect { service_response }.to create_audit_event(
        :team_role_created,
        author_id: current_user.id,
        entity_type: 'TeamRole',
        details: { name: role_name },
        target_id: team.id,
        target_type: 'Team'
      )
    end
  end
end
