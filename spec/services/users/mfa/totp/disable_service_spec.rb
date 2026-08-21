# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Mfa::Totp::DisableService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), current_totp).execute
  end

  context 'when user is nil' do
    let(:current_user) { nil }
    let(:current_totp) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }
  end

  context 'when user is valid but totp secret is not set' do
    let(:current_user) { create(:user) }
    let(:current_totp) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:totp_secret_not_set) }
  end

  context 'when user is valid and totp secret is set but totp is wrong' do
    let(:secret) { ROTP::Base32.random }
    let(:current_user) { create(:user, totp_secret: secret) }
    let(:current_totp) { '00000' }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:wrong_totp) }
    it { is_expected.not_to create_audit_event }
  end

  context 'when user is valid and totp is valid' do
    let(:secret) { ROTP::Base32.random }
    let(:current_user) { create(:user, totp_secret: secret) }
    let(:current_totp) { ROTP::TOTP.new(secret).now }

    it { is_expected.to be_success }

    it {
      expect do
        service_response
      end.to change {
        current_user.reload.totp_secret
      }.from(secret).to(nil)
    }

    it {
      is_expected.to create_audit_event(
        :mfa_disabled,
        author_id: current_user.id,
        entity_type: 'User',
        entity_id: current_user.id,
        target_type: 'User',
        target_id: current_user.id,
        details: { type: 'totp' }
      )
    }
  end
end
