# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::DeleteService do
  subject(:service_response) { described_class.new(create_authentication(current_user), organization).execute }

  let!(:organization) { create(:organization) }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { Organization.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { Organization.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      create(:namespace_member, namespace: organization.ensure_namespace, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :delete_organization, user: current_user, subject: organization)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(organization) }
    it { expect { service_response }.to change { Organization.count }.by(-1) }

    it do
      expect { service_response }.to create_audit_event(
        :organization_deleted,
        author_id: current_user.id,
        entity_type: 'Organization',
        details: {},
        target_id: organization.namespace.id,
        target_type: 'Namespace'
      )
    end
  end
end
