# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::EmailVerificationService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), authentication_token).execute
  end

  let(:current_user) { create(:user) }
  let(:authentication_token) { current_user&.generate_token_for(:email_verification) }

  shared_examples 'does not update' do
    it { is_expected.to be_error }

    it { expect { service_response }.not_to create_audit_event }
    it { expect { service_response }.not_to change { current_user&.reload&.email_verified_at } }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }

    it_behaves_like 'does not update'
  end

  context 'when params are invalid' do
    context 'when token is invalid' do
      let(:authentication_token) { 'invalidtoken' }

      it { expect(service_response.payload).to eq(:missing_permission) }

      it_behaves_like 'does not update'
    end
  end

  context 'when user and params are valid' do
    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it 'updates user' do
      expect { service_response }.to change { current_user.reload.email_verified_at }.from(nil)
    end

    it do
      is_expected.to create_audit_event(
        :email_verified,
        author_id: current_user.id,
        entity_type: 'User',
        details: { email: current_user.email },
        target_type: 'User'
      )
    end
  end
end
