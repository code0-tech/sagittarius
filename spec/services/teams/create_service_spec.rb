# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Teams::CreateService do
  subject(:service_response) { described_class.new(current_user, **params).execute }

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create team' do
      expect { service_response }.not_to change { Team.count }
    end

    it 'does not create team member' do
      expect { service_response }.not_to change { TeamMember.count }
    end

    it { expect { service_response }.not_to create_audit_event(:team_created) }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    let(:params) do
      { name: generate(:team_name) }
    end

    it_behaves_like 'does not create'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }

    context 'when name is to long' do
      let(:params) { { name: generate(:team_name) + ('*' * 50) } }

      it_behaves_like 'does not create'
    end

    context 'when name is to short' do
      let(:params) { { name: 'a' } }

      it_behaves_like 'does not create'
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }
    let(:params) do
      { name: generate(:team_name) }
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it 'adds current_user as team member' do
      team = service_response.payload.reload
      member = TeamMember.find_by(team: team, user: current_user)

      expect(member).to be_present
    end

    it 'only adds 1 member' do
      expect { service_response }.to change { TeamMember.count }.by(1)
    end

    it do
      is_expected.to create_audit_event(
        :team_created,
        author_id: current_user.id,
        entity_type: 'Team',
        details: { name: params[:name] },
        target_type: 'Team'
      )
    end
  end
end
