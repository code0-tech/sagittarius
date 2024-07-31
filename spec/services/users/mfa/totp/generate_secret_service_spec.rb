# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Mfa::Totp::GenerateSecretService do
  subject(:service_response) { described_class.new(current_user).execute }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
  end

  context 'when user is valid' do
    context 'totp secret is already set' do
      let(:current_user) { create(:user, totp_secret: ROTP::Base32.random) }

      it { is_expected.to_not be_success }
      it { expect(service_response.payload).to eq(:totp_secret_already_set) }
    end
    context 'totp secret is not set' do
      let(:current_user) { create(:user) }

      it { is_expected.to be_success }

      it 'is valid totp secret' do
        totp = ROTP::TOTP.new(service_response.payload.split('--').first)
        expect(totp.secret.length).to eq(48)
      end
    end

  end
end
