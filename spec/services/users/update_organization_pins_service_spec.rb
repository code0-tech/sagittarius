# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::UpdateOrganizationPinsService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), organization_ids).execute
  end

  let(:user) { create(:user) }
  let(:organization_a) { create(:organization) }
  let(:organization_b) { create(:organization) }
  let(:organization_ids) { [organization_b.id, organization_a.id] }

  before do
    [organization_a, organization_b].each do |organization|
      create(:namespace_member, namespace: organization.ensure_namespace, user: user)
    end
  end

  context 'when current user is missing' do
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

      pins = user.reload.user_organization_pins
      expect(pins.pluck(:organization_id)).to eq(organization_ids)
      expect(pins.pluck(:priority)).to eq([0, 1])
    end

    it 'creates an audit event' do
      expect { service_response }.to create_audit_event(
        :user_organization_pins_updated,
        author_id: current_user.id,
        entity_type: 'User',
        target_type: 'User'
      )
    end
  end

  context 'when a pin cannot be saved' do
    let(:current_user) { user }
    let(:pins_association) { user.user_organization_pins }

    before do
      allow(user).to receive(:user_organization_pins).and_return(pins_association)
      allow(pins_association).to receive(:build).and_wrap_original do |original_method, *args|
        original_method.call(*args).tap do |pin|
          allow(pin).to receive(:save).and_return(false)
        end
      end
    end

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:invalid_user_organization_pin) }
    it { expect { service_response }.not_to create_audit_event }
  end
end
