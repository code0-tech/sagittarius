# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::PasswordResetService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), authentication_token, mfa, new_password).execute
  end

  let(:current_user) { create(:user, :mfa_totp) }
  let(:authentication_token) { current_user&.generate_token_for(:password_reset) }
  let(:new_password) { generate(:password) }
  let(:mfa) { nil }



  shared_examples 'user doesnt verify' do
    it { is_expected.to be_error }

    it { expect { service_response }.not_to create_audit_event }
    it { expect { service_response }.not_to change { current_user&.reload&.password_digest } }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }

    it_behaves_like 'user doesnt verify'
  end

  context 'when params are invalid' do
    context 'when token is invalid' do
      let(:authentication_token) { 'invalidtoken' }

      it { expect(service_response.payload).to eq(:missing_permission) }

      it_behaves_like 'user doesnt verify'
    end
  end

  context 'when user and params are valid' do
    let(:otp) { ROTP::TOTP.new(current_user.totp_secret).now }
    let(:mfa) do
      { type: :totp, value: otp }
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it 'updates user' do
      expect { service_response }.to change { current_user.reload.password_digest }
    end

    it do
      is_expected.to create_audit_event(
        :password_reset,
        author_id: current_user.id,
        entity_type: 'User',
        details: { mfa_type: "totp" },
        target_type: 'User',
        target_id: current_user.id
      )
    end
  end
end
