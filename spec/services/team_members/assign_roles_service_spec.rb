# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamMembers::AssignRolesService do
  subject(:service_response) { described_class.new(current_user, member, roles).execute }

  let(:current_user) { create(:user) }
  let(:team) { create(:team) }
  let(:member) { create(:team_member, team: team) }
  let(:roles) { [] }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationMemberRole.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_member_roles_updated)
    end
  end

  context 'when user does not have permission' do
    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationMemberRole.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_member_roles_updated)
    end
  end

  context 'when user has permission' do
    context 'when adding a role' do
      let(:team_role) { create(:team_role, team: team) }
      let(:roles) { [team_role] }

      before do
        stub_allowed_ability(TeamPolicy, :assign_member_roles, user: current_user, subject: team)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload.map(&:role)).to eq([team_role]) }
      it { expect { service_response }.to change { OrganizationMemberRole.count }.by(1) }

      it do
        expect { service_response }.to create_audit_event(
          :organization_member_roles_updated,
          author_id: current_user.id,
          entity_type: 'TeamMember',
          details: { 'old_roles' => [], 'new_roles' => [{ 'id' => team_role.id, 'name' => team_role.name }] },
          target_id: team.id,
          target_type: 'Team'
        )
      end
    end

    context 'when removing a role' do
      let(:team_role) { create(:team_role, team: team) }
      let(:roles) { [] }

      before do
        create(:organization_member_role, member: member, role: team_role)
        stub_allowed_ability(TeamPolicy, :assign_member_roles, user: current_user, subject: team)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload.map(&:role)).to eq([]) }
      it { expect { service_response }.to change { OrganizationMemberRole.count }.by(-1) }

      it do
        expect { service_response }.to create_audit_event(
          :organization_member_roles_updated,
          author_id: current_user.id,
          entity_type: 'TeamMember',
          details: {
            'old_roles' => [{ 'id' => team_role.id, 'name' => team_role.name }],
            'new_roles' => [],
          },
          target_id: team.id,
          target_type: 'Team'
        )
      end
    end

    context 'when adding and removing a role' do
      let(:adding_team_role) { create(:team_role, team: team) }
      let(:removing_team_role) { create(:team_role, team: team) }
      let(:roles) { [adding_team_role] }

      before do
        create(:organization_member_role, member: member, role: removing_team_role)
        stub_allowed_ability(TeamPolicy, :assign_member_roles, user: current_user, subject: team)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload.map(&:role)).to eq([adding_team_role]) }
      it { expect { service_response }.not_to change { OrganizationMemberRole.count } }

      it do
        expect { service_response }.to create_audit_event(
          :organization_member_roles_updated,
          author_id: current_user.id,
          entity_type: 'TeamMember',
          details: {
            'old_roles' => [{ 'id' => removing_team_role.id, 'name' => removing_team_role.name }],
            'new_roles' => [{ 'id' => adding_team_role.id, 'name' => adding_team_role.name }],
          },
          target_id: team.id,
          target_type: 'Team'
        )
      end
    end

    context 'when roles and member belong to different teams' do
      let(:roles) { [create(:team_role)] }

      before do
        stub_allowed_ability(TeamPolicy, :assign_member_roles, user: current_user, subject: team)
      end

      it { is_expected.not_to be_success }
      it { expect(service_response.payload).to eq(:inconsistent_team) }
      it { expect { service_response }.not_to change { OrganizationMemberRole.count } }

      it do
        expect { service_response }.not_to create_audit_event(:organization_member_roles_updated)
      end
    end
  end
end
