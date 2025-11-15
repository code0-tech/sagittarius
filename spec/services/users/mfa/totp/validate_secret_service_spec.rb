# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Mfa::Totp::ValidateSecretService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), signed_secret, current_totp).execute
  end

  context 'when user is nil' do
    let(:current_user) { nil }
    let(:current_totp) { nil }
    let(:signed_secret) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }
  end

  context 'when user is valid but totp secret is already set' do
    let(:current_user) { create(:user, totp_secret: ROTP::Base32.random) }
    let(:current_totp) { nil }
    let(:signed_secret) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:totp_secret_already_set) }
  end

  context 'when user and secret is valid but totp is not' do
    let(:current_user) { create(:user) }
    let(:secret) { ROTP::Base32.random }
    let(:signed_secret) { Rails.application.message_verifier(:totp_secret).generate(secret) }
    let(:current_totp) { '00000' }

    it { is_expected.not_to be_success }
    it { is_expected.not_to create_audit_event }
  end

  context 'when user is valid and secret is valid and totp is valid' do
    let(:current_user) { create(:user) }
    let(:secret) { ROTP::Base32.random }
    let(:signed_secret) { Rails.application.message_verifier(:totp_secret).generate(secret) }
    let(:current_totp) { ROTP::TOTP.new(secret).now }

    it { is_expected.to be_success }

    it {
      expect do
        service_response
      end.to change {
        current_user.reload.totp_secret
      }.to(secret)
    }

    it {
      is_expected.to create_audit_event(
        :mfa_enabled,
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
