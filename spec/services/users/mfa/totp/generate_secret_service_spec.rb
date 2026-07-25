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
      include ActiveSupport::Testing::TimeHelpers

      let(:current_user) { create(:user) }

      it { is_expected.to be_success }

      it 'returns a valid totp secret' do
        secret = service_response.payload[:secret]
        totp = ROTP::TOTP.new(secret)
        expect(totp.now).to be_present
      end

      it 'returns a matching secret' do
        signed_secret = Rails.application.message_verifier(:totp_secret).verified(
          service_response.payload[:signed_secret]
        )
        expect(signed_secret).to eq(service_response.payload[:secret])
      end

      it 'returns a signed secret that expires' do
        signed_secret = service_response.payload[:signed_secret]

        travel_to 31.minutes.from_now do
          expect(Rails.application.message_verifier(:totp_secret).verified(signed_secret)).to be_nil
        end
      end
    end
  end
end
