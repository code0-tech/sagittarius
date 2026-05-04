# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::UpdateOrganizationPinsService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), user, organization_ids).execute
  end

  let(:user) { create(:user) }
  let(:organization_a) { create(:organization) }
  let(:organization_b) { create(:organization) }
  let(:organization_ids) { [organization_a.id, organization_b.id] }

  context 'when current user cannot update target user' do
    let(:current_user) { nil }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }
    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when an organization does not exist' do
    let(:current_user) { user }
    let(:organization_ids) { [organization_a.id, 999_999] }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:organization_not_found) }
    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when input is valid' do
    let(:current_user) { user }

    before do
      create(:user_organization_pin, user: user, organization: create(:organization), priority: 0)
    end

    it { is_expected.to be_success }

    it 'replaces pins in given order with priorities' do
      service_response

      pins = user.reload.user_organization_pins.order(:priority)
      expect(pins.pluck(:organization_id)).to eq(organization_ids)
      expect(pins.pluck(:priority)).to eq([0, 1])
    end

    it 'creates an audit event' do
      expect { service_response }.to create_audit_event(
        :user_updated,
        author_id: current_user.id,
        entity_type: 'User',
        target_type: 'User'
      )
    end
  end
end
