# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationMembers::DeleteService do
  subject(:service_response) { described_class.new(current_user, organization_member).execute }

  let(:organization) { create(:organization) }
  let!(:organization_member) { create(:organization_member, organization: organization) }
  let!(:admin_role) do
    create(:organization_role, organization: organization).tap do |role|
      create(:organization_role_ability, organization_role: role, ability: :organization_administrator)
      create(:organization_member_role, role: role)
    end
  end
  let!(:admin) do
    create(:organization_member, organization: organization).tap do |member|
      create(:organization_member_role, member: member, role: admin_role)
    end
  end

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationMember.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_member_deleted)
    end
  end

  context 'when user is not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationMember.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_member_deleted)
    end
  end

  context 'when user is the last admin' do
    let(:current_user) { create(:user) }

    before do
      create(:organization_member, organization: organization, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :delete_member, user: current_user, subject: organization)
      admin.delete
      admin_role.delete
    end

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:cannot_remove_last_administrator) }
    it { expect { service_response }.not_to change { OrganizationMember.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_member_deleted)
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      create(:organization_member, organization: organization, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :delete_member, user: current_user, subject: organization)
    end

    it { is_expected.to be_success }
    it { expect { service_response }.to change { OrganizationMember.count }.by(-1) }

    it do
      expect { service_response }.to create_audit_event(
        :organization_member_deleted,
        author_id: current_user.id,
        entity_type: 'OrganizationMember',
        details: {},
        target_id: organization.id,
        target_type: 'Organization'
      )
    end
  end
end
