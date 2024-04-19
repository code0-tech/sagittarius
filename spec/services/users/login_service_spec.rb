# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::LoginService do
  subject(:service_response) { described_class.new(email: email, password: password).execute }

  context 'when the credentials are correct' do
    let(:email) { generate(:email) }
    let(:password) { generate(:password) }
    let!(:current_user) { create(:user, email: email, password: password) }

    it 'returns a success response' do
      expect(service_response).to be_success
      expect(service_response.payload).to be_a(UserSession)
      expect(service_response.payload.user.id).to eq(current_user.id)
      expect(service_response.payload.token).to be_present
      is_expected.to create_audit_event(
        :user_logged_in,
        author_id: current_user.id,
        entity_type: 'User',
        entity_id: current_user.id,
        details: { email: current_user.email, method: 'username_and_password' },
        target_type: 'User',
        target_id: current_user.id
      )
    end
  end

  context 'when the credentials are incorrect' do
    let(:email) { generate(:email) }
    let(:password) { generate(:password) }

    it 'returns an error response' do
      expect(service_response).to be_error
      expect(service_response.message).to eq('Invalid login data')
      is_expected.not_to create_audit_event(:user_logged_in)
    end
  end
end
