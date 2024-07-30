# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::LoginService do
  subject(:service_response) { described_class.new(**params).execute }

  context 'when the credentials are correct' do
    let(:email) { generate(:email) }
    let(:username) { generate(:username) }
    let(:password) { generate(:password) }
    let!(:current_user) { create(:user, email: email, username: username, password: password) }

    shared_examples 'creates correct audit event' do |key, other_key, mfa_type|
      it do
        is_expected.to create_audit_event(
                         :user_logged_in,
                         author_id: current_user.id,
                         entity_type: 'User',
                         entity_id: current_user.id,
                         details: { key => current_user.send(key), method: 'username_and_password',
                                    mfa_type: mfa_type },
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
    context 'when using mfa' do

      context 'when mfa is not activated' do
        let(:params) do
          { username: username, password: password, mfa: { type: :totp, value: nil } }
        end
        it 'should fail' do
          expect(service_response).not_to be_success
          expect(service_response.payload).to eq(:mfa_failed)
          is_expected.not_to create_audit_event
        end

      end

      context 'when using a backup code' do
        let!(:current_user) do
          create(:user, email: email, username: username, password: password, totp_secret: ROTP::Base32.random)
        end
        let!(:backup_code) { create(:backup_code, user: current_user) }

        context 'when backup code is valid' do
          let(:params) do
            { username: username, password: password, mfa: { type: :backup_code, value: backup_code.token } }
          end

          it { expect { service_response }.to change { BackupCode.count }.by(-1) }

          it_behaves_like 'check correct credentials'
          it_behaves_like 'creates correct audit event', :username, :email, 'backup_code'
        end

        context 'when backup code is invalid' do
          let(:params) { { username: username, password: password, mfa: { type: :backup_code, value: '1234567890' } } }

          it { expect { service_response }.not_to change { BackupCode.count } }
          it { expect(service_response).not_to be_success }
        end
      end

      context 'when user has enabled TOTP' do
        let(:totp_secret) { ROTP::Base32.random }

        before do
          current_user.totp_secret = totp_secret
          current_user.save!
        end

        context 'when otp is valid' do
          let(:otp) { ROTP::TOTP.new(totp_secret).now }
          let(:params) { { username: username, password: password, mfa: { type: :totp, value: otp } } }

          it_behaves_like 'check correct credentials'
          it_behaves_like 'creates correct audit event', :username, :email, 'totp'
        end

        context 'when otp is invalid' do
          let(:params) { { username: username, password: password, mfa: { type: :totp, value: '000000' } } }

          it 'returns an error response' do
            expect(service_response).to be_error
            expect(service_response.payload).to eq(:mfa_failed)
            is_expected.not_to create_audit_event
          end
        end
      end
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
