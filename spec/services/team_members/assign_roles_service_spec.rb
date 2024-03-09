# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamMembers::AssignRolesService do
  subject(:service_response) { described_class.new(current_user, member, roles).execute }

  let(:current_user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:member) { create(:organization_member, organization: organization) }
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
      let(:organization_role) { create(:organization_role, organization: organization) }
      let(:roles) { [organization_role] }

      before do
        stub_allowed_ability(OrganizationPolicy, :assign_member_roles, user: current_user, subject: organization)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload.map(&:role)).to eq([organization_role]) }
      it { expect { service_response }.to change { OrganizationMemberRole.count }.by(1) }

      it do
        expect { service_response }.to create_audit_event(
          :organization_member_roles_updated,
          author_id: current_user.id,
          entity_type: 'OrganizationMember',
          details: {
            'old_roles' => [],
            'new_roles' => [{ 'id' => organization_role.id, 'name' => organization_role.name }],
          },
          target_id: organization.id,
          target_type: 'Organization'
        )
      end
    end

    context 'when removing a role' do
      let(:organization_role) { create(:organization_role, organization: organization) }
      let(:roles) { [] }

      before do
        create(:organization_member_role, member: member, role: organization_role)
        stub_allowed_ability(OrganizationPolicy, :assign_member_roles, user: current_user, subject: organization)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload.map(&:role)).to eq([]) }
      it { expect { service_response }.to change { OrganizationMemberRole.count }.by(-1) }

      it do
        expect { service_response }.to create_audit_event(
          :organization_member_roles_updated,
          author_id: current_user.id,
          entity_type: 'OrganizationMember',
          details: {
            'old_roles' => [{ 'id' => organization_role.id, 'name' => organization_role.name }],
            'new_roles' => [],
          },
          target_id: organization.id,
          target_type: 'Organization'
        )
      end
    end

    context 'when adding and removing a role' do
      let(:adding_organization_role) { create(:organization_role, organization: organization) }
      let(:removing_organization_role) { create(:organization_role, organization: organization) }
      let(:roles) { [adding_organization_role] }

      before do
        create(:organization_member_role, member: member, role: removing_organization_role)
        stub_allowed_ability(OrganizationPolicy, :assign_member_roles, user: current_user, subject: organization)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload.map(&:role)).to eq([adding_organization_role]) }
      it { expect { service_response }.not_to change { OrganizationMemberRole.count } }

      it do
        expect { service_response }.to create_audit_event(
          :organization_member_roles_updated,
          author_id: current_user.id,
          entity_type: 'OrganizationMember',
          details: {
            'old_roles' => [{ 'id' => removing_organization_role.id, 'name' => removing_organization_role.name }],
            'new_roles' => [{ 'id' => adding_organization_role.id, 'name' => adding_organization_role.name }],
          },
          target_id: organization.id,
          target_type: 'Organization'
        )
      end
    end

    context 'when roles and member belong to different organizations' do
      let(:roles) { [create(:organization_role)] }

      before do
        stub_allowed_ability(OrganizationPolicy, :assign_member_roles, user: current_user, subject: organization)
      end

      it { is_expected.not_to be_success }
      it { expect(service_response.payload).to eq(:inconsistent_organization) }
      it { expect { service_response }.not_to change { OrganizationMemberRole.count } }

      it do
        expect { service_response }.not_to create_audit_event(:organization_member_roles_updated)
      end
    end
  end
end
