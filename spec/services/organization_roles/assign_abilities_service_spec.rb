# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationRoles::AssignAbilitiesService do
  subject(:service_response) { described_class.new(current_user, role, abilities).execute }

  let(:current_user) { create(:user) }
  let(:role) { create(:organization_role) }
  let(:abilities) { [] }

  let!(:admin_role) do
    create(:organization_role, organization: role.organization).tap do |role|
      create(:organization_role_ability, organization_role: role, ability: :organization_administrator)
    end
  end

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationRoleAbility.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_role_abilities_updated)
    end
  end

  context 'when user does not have permission' do
    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationRoleAbility.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_role_abilities_updated)
    end
  end

  context 'when user has permission' do
    context 'when ability is last admin ability' do
      let(:abilities) { [] }

      before do
        stub_allowed_ability(OrganizationPolicy, :assign_role_abilities, user: current_user, subject: role.organization)
        create(:organization_role_ability, organization_role: role, ability: :organization_administrator)
        admin_role.delete
      end

      it { is_expected.not_to be_success }
      it { expect(service_response.payload).to eq(:cannot_remove_last_admin_ability) }
      it { expect { service_response }.not_to change { OrganizationRoleAbility.count } }

      it do
        expect { service_response }.not_to create_audit_event(:organization_role_abilities_updated)
      end
    end

    context 'when adding an ability' do
      let(:abilities) { [:create_organization_role] }

      before do
        stub_allowed_ability(OrganizationPolicy, :assign_role_abilities, user: current_user, subject: role.organization)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload).to eq(['create_organization_role']) }
      it { expect { service_response }.to change { OrganizationRoleAbility.count }.by(1) }

      it do
        expect { service_response }.to create_audit_event(
          :organization_role_abilities_updated,
          author_id: current_user.id,
          entity_id: role.id,
          entity_type: 'OrganizationRole',
          details: { 'old_abilities' => [], 'new_abilities' => ['create_organization_role'] },
          target_id: role.organization.id,
          target_type: 'Organization'
        )
      end
    end

    context 'when removing an ability' do
      let(:abilities) { [] }

      before do
        create(:organization_role_ability, organization_role: role, ability: :create_organization_role)
        stub_allowed_ability(OrganizationPolicy, :assign_role_abilities, user: current_user, subject: role.organization)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload).to be_empty }
      it { expect { service_response }.to change { OrganizationRoleAbility.count }.by(-1) }

      it do
        expect { service_response }.to create_audit_event(
          :organization_role_abilities_updated,
          author_id: current_user.id,
          entity_id: role.id,
          entity_type: 'OrganizationRole',
          details: { 'old_abilities' => ['create_organization_role'], 'new_abilities' => [] },
          target_id: role.organization.id,
          target_type: 'Organization'
        )
      end
    end

    context 'when adding and removing an ability' do
      let(:abilities) { [:create_organization_role] }

      before do
        create(:organization_role_ability, organization_role: role, ability: :invite_member)
        stub_allowed_ability(OrganizationPolicy, :assign_role_abilities, user: current_user, subject: role.organization)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload).to eq(['create_organization_role']) }
      it { expect { service_response }.not_to change { OrganizationRoleAbility.count } }

      it do
        expect { service_response }.to create_audit_event(
          :organization_role_abilities_updated,
          author_id: current_user.id,
          entity_id: role.id,
          entity_type: 'OrganizationRole',
          details: {
            'old_abilities' => ['invite_member'],
            'new_abilities' => ['create_organization_role'],
          },
          target_id: role.organization.id,
          target_type: 'Organization'
        )
      end
    end
  end
end
