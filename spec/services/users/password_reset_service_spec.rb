# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::PasswordResetService do
  subject(:service_response) do
    described_class.new(authentication_token, new_password).execute
  end

  let(:current_user) { create(:user) }
  let(:authentication_token) { current_user&.generate_token_for(:password_reset) }
  let(:new_password) { generate(:password) }

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

      it { expect(service_response.payload).to eq(:invalid_verification_code) }

      it_behaves_like 'user doesnt verify'
    end
  end

  context 'when user and params are valid' do
    it { is_expected.to be_success }
    it { expect(service_response.message).to eq('Successfully reset password') }

    it 'updates user' do
      expect { service_response }.to change { current_user.reload.password_digest }
    end

    it do
      is_expected.to create_audit_event(
        :password_reset,
        author_id: current_user.id,
        entity_type: 'User',
        details: {},
        target_type: 'User',
        target_id: current_user.id
      )
    end
  end
end
