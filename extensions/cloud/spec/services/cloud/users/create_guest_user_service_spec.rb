# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CLOUD::Users::CreateGuestUserService do
  subject(:service_response) do
    described_class.new(current_authentication, username: username, email: email).execute
  end

  let(:username) { generate(:username) }
  let(:email) { generate(:email) }

  shared_examples 'does not create a guest user' do
    before { current_authentication }

    it { is_expected.to be_error }

    it 'does not create a user' do
      expect { service_response }.not_to change { User.count }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when authenticated as crater' do
    let!(:crater_user) { create(:user, :crater) }
    let(:current_authentication) do
      Sagittarius::Authentication.new(:crater, CLOUD::ApplicationController::CraterToken.new(user: crater_user))
    end

    it { is_expected.to be_success }

    it 'creates a guest user' do
      expect { service_response }.to change { User.count }.by(1)
    end

    it 'sets the guest user type' do
      expect(service_response.payload).to be_guest
    end

    it 'sets username and email' do
      expect(service_response.payload.username).to eq(username)
      expect(service_response.payload.email).to eq(email)
    end

    it do
      is_expected.to create_audit_event(
        :guest_user_created,
        author_id: crater_user.id,
        entity_type: 'User',
        details: { 'username' => username, 'email' => email },
        target_type: 'global'
      )
    end
  end

  context 'when not authenticated as crater' do
    let(:current_authentication) { create_authentication(create(:user)) }

    it_behaves_like 'does not create a guest user'
  end

  context 'when anonymous' do
    let(:current_authentication) { create_authentication(nil) }

    it_behaves_like 'does not create a guest user'
  end
end
