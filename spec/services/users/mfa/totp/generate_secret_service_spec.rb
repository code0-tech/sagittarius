# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Mfa::Totp::GenerateSecretService do
  subject(:service_response) { described_class.new(create_authentication(current_user)).execute }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }
  end

  context 'when user is valid' do
    context 'when totp secret is already set' do
      let(:current_user) { create(:user, totp_secret: ROTP::Base32.random) }

      it { is_expected.not_to be_success }
      it { expect(service_response.payload[:error_code]).to eq(:totp_secret_already_set) }
    end

    context 'when totp secret is not set' do
      let(:current_user) { create(:user) }

      it { is_expected.to be_success }

      it 'is valid totp secret' do
        totp = ROTP::TOTP.new(service_response.payload[:signed_secret].split('--').first)
        expect(totp.secret.length).to eq(48)
      end

      it 'returns a matching secret' do
        signed_totp = Rails.application.message_verifier(:totp_secret).verify(service_response.payload[:signed_secret])
        expect(signed_totp).to eq(service_response.payload[:secret])
      end
    end
  end
end
