# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Mfa::BackupCodes::RotateService do
  subject(:service_response) { described_class.new(create_authentication(current_user), mfa).execute }

  let(:mfa) { nil }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }
  end

  context 'when user is valid and mfa is not enabled' do
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

  context 'when user has mfa enabled' do
    let(:secret) { ROTP::Base32.random }
    let(:current_user) { create(:user, totp_secret: secret) }

    context 'when no mfa is provided' do
      let(:mfa) { nil }

      it { is_expected.not_to be_success }
      it { expect(service_response.payload[:error_code]).to eq(:mfa_required) }
      it { is_expected.not_to create_audit_event }
      it { expect { service_response }.not_to change { current_user.reload.backup_codes.to_a } }
    end

    context 'when the provided mfa is wrong' do
      let(:mfa) { { type: :totp, value: '00000' } }

      it { is_expected.not_to be_success }
      it { expect(service_response.payload[:error_code]).to eq(:mfa_failed) }
      it { is_expected.not_to create_audit_event }
      it { expect { service_response }.not_to change { current_user.reload.backup_codes.to_a } }
    end

    context 'when a valid totp is provided' do
      let(:mfa) { { type: :totp, value: ROTP::TOTP.new(secret).now } }

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

    context 'when a valid backup code is provided' do
      let(:mfa) { { type: :backup_code, value: 'valid-code' } }

      before { create(:backup_code, user: current_user, token: 'valid-code') }

      it { is_expected.to be_success }

      it { expect { service_response }.to change { current_user.reload.backup_codes } }
    end
  end
end
