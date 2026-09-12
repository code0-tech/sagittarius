# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::CompleteGuestProfileService do
  subject(:service_response) do
    described_class.new(
      claim_token,
      username: username,
      password: password,
      firstname: 'First',
      lastname: 'Last'
    ).execute
  end

  let(:guest) { create(:user, :guest) }
  let(:claim_token) { guest.generate_token_for(:guest_claim) }
  let(:username) { generate(:username) }
  let(:password) { generate(:password) }

  context 'with a valid claim token' do
    it { is_expected.to be_success }

    it 'promotes the guest to a regular user' do
      expect(service_response.payload.user).to be_regular
    end

    it 'sets the profile fields' do
      user = service_response.payload.user

      expect(user.username).to eq(username)
      expect(user.firstname).to eq('First')
      expect(user.lastname).to eq('Last')
      expect(user.email_verified_at).to be_present
    end

    it 'returns a usable session' do
      expect(service_response.payload).to be_a(UserSession)
      expect(service_response.payload.token).to be_present
    end

    it do
      is_expected.to create_audit_event(
        :guest_profile_completed,
        author_id: guest.id,
        entity_type: 'User',
        details: { 'username' => username },
        target_type: 'User'
      )
    end
  end

  context 'when the claim token is invalid' do
    let(:claim_token) { 'invalid-token' }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:invalid_verification_code) }
  end

  context 'when the claim token has already been used' do
    before do
      claim_token
      guest.update!(password: generate(:password))
    end

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:invalid_verification_code) }
  end

  context 'when the token belongs to a non-guest user' do
    let(:guest) { create(:user) }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:invalid_verification_code) }
  end
end
