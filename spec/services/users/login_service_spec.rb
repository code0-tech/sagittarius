# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::LoginService do
  subject(:service_response) { described_class.new(**params).execute }

  context 'when the credentials are correct' do
    let(:email) { generate(:email) }
    let(:username) { generate(:username) }
    let(:password) { generate(:password) }
    let!(:current_user) { create(:user, email: email, username: username, password: password) }

    shared_examples 'creates correct audit event' do |key, other_key|
      it do
        is_expected.to create_audit_event(
          :user_logged_in,
          author_id: current_user.id,
          entity_type: 'User',
          entity_id: current_user.id,
          details: { key => current_user.send(key), method: 'username_and_password' },
          target_type: 'User',
          target_id: current_user.id
        )
        is_expected.not_to create_audit_event(
          :user_logged_in,
          details: { other_key => current_user.send(other_key), method: 'username_and_password' }
        )
      end
    end

    shared_examples 'check correct credentials' do
      it do
        expect(service_response).to be_success
        expect(service_response.payload).to be_a(UserSession)
        expect(service_response.payload.user.id).to eq(current_user.id)
        expect(service_response.payload.token).to be_present
      end
    end

    context 'when logging in with email' do
      let(:params) { { email: email, password: password } }

      it_behaves_like 'check correct credentials'
      it_behaves_like 'creates correct audit event', :email, :username
    end

    context 'when logging in with username' do
      let(:params) { { username: username, password: password } }

      it_behaves_like 'check correct credentials'
      it_behaves_like 'creates correct audit event', :username, :email
    end
  end

  context 'when the credentials are incorrect' do
    let(:email) { generate(:email) }
    let(:password) { generate(:password) }
    let(:params) { { email: email, password: password } }

    it 'returns an error response' do
      expect(service_response).to be_error
      expect(service_response.message).to eq('Invalid login data')
      is_expected.not_to create_audit_event
    end
  end
end
