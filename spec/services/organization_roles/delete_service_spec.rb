# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationRoles::DeleteService do
  subject(:service_response) { described_class.new(current_user, organization_role).execute }

  let!(:organization_role) { create(:organization_role) }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationRole.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_role_deleted)
    end
  end

  context 'when user is not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { OrganizationRole.count } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_role_deleted)
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      create(:organization_member, organization: organization_role.organization, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :delete_organization_role, user: current_user,
                                                                          subject: organization_role.organization)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(organization_role) }
    it { expect { service_response }.to change { OrganizationRole.count }.by(-1) }

    it do
      expect { service_response }.to create_audit_event(
        :organization_role_deleted,
        author_id: current_user.id,
        entity_type: 'OrganizationRole',
        details: {},
        target_id: organization_role.organization.id,
        target_type: 'Organization'
      )
    end
  end
end
