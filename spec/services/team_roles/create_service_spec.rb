# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamRoles::CreateService do
  subject(:service_response) { described_class.new(current_user, organization, params).execute }

  let(:organization) { create(:organization) }
  let(:role_name) { generate(:role_name) }
  let(:params) { { name: role_name } }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationRole.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_role_created)
    end
  end

  context 'when user is not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationRole.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_role_created)
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      create(:organization_member, organization: organization, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :create_organization_role, user: current_user, subject: organization)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.organization).to eq(organization) }
    it { expect(service_response.payload.name).to eq(role_name) }
    it { expect { service_response }.to change { OrganizationRole.count }.by(1) }

    it do
      expect { service_response }.to create_audit_event(
        :organization_role_created,
        author_id: current_user.id,
        entity_type: 'OrganizationRole',
        details: { name: role_name },
        target_id: organization.id,
        target_type: 'Organization'
      )
    end
  end
end
