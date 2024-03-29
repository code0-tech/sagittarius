# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationMembers::InviteService do
  subject(:service_response) { described_class.new(current_user, organization, user).execute }

  let(:organization) { create(:organization) }
  let(:user) { create(:user) }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationMember.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_member_invited)
    end
  end

  context 'when user does not have permission' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationMember.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_member_invited)
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      stub_allowed_ability(OrganizationPolicy, :invite_member, user: current_user, subject: organization)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.organization).to eq(organization) }
    it { expect(service_response.payload.user).to eq(user) }
    it { expect { service_response }.to change { OrganizationMember.count }.by(1) }

    it do
      expect { service_response }.to create_audit_event(
        :organization_member_invited,
        author_id: current_user.id,
        entity_type: 'OrganizationMember',
        details: {},
        target_id: organization.id,
        target_type: 'Organization'
      )
    end
  end
end
