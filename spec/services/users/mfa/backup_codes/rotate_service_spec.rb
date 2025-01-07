# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Mfa::BackupCodes::RotateService do
  subject(:service_response) { described_class.new(create_authentication(current_user)).execute }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
  end

  context 'when user is valid' do
    let(:current_user) { create(:user) }

    it { is_expected.to be_success }

    it { expect { service_response }.to change { current_user.reload.backup_codes } }

    it {
      is_expected.to create_audit_event(
        :backup_codes_rotated,
        author_id: current_user.id,
        entity_type: 'User',
        entity_id: current_user.id,
        target_type: 'User',
        target_id: current_user.id,
        details: {}
      )
    }
  end
end
