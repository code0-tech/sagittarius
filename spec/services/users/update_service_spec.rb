# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::UpdateService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), current_user, mfa, params).execute
  end

  let(:mfa) { nil }

  shared_examples 'does not update' do
    it { is_expected.to be_error }

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    let(:params) do
      { username: generate(:username) }
    end

    it_behaves_like 'does not update'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }
    let(:user) { create(:user) }

    context 'when name is to long' do
      let(:params) { { username: generate(:username) + ('*' * 50) } }

      it_behaves_like 'does not update'
    end
  end

  context 'when user and params are valid' do
    let(:params) do
      { username: generate(:username),
        password: generate(:password) }
    end
    let(:current_user) { create(:user) }

    context 'when user tries to update admin status' do
      subject(:service_response) { described_class.new(create_authentication(current_user), user, mfa, params).execute }

      context 'when user is admin' do
        let(:params) do
          { admin: true }
        end
        let(:current_user) { create(:user, :admin) }
        let(:user) { create(:user) }

        context 'when user is trying to modify its own admin status' do
          let(:user) { current_user }
          let(:params) do
            { admin: true }
          end

          it { is_expected.not_to be_success }

          it 'does not update user' do
            expect { service_response }.not_to change { user.reload.admin }
          end

          it do
            is_expected.not_to create_audit_event
          end
        end

        it { is_expected.to be_success }
        it { expect(service_response.payload.reload).to be_valid }

        it 'updates user' do
          expect { service_response }.to change { user.reload.admin }.from(user.admin).to(params[:admin])
        end

        it do
          is_expected.to create_audit_event(
            :user_updated,
            author_id: current_user.id,
            entity_type: 'User',
            details: { admin: params[:admin] },
            target_type: 'User'
          )
        end
      end

      context 'when user is not admin' do
        let(:user) { create(:user) }
        let(:current_user) { create(:user) }
        let(:params) do
          { admin: true }
        end

        it { is_expected.not_to be_success }

        it 'updates user' do
          expect { service_response }.not_to change { user.reload.admin }
        end

        it do
          is_expected.not_to create_audit_event
        end
      end
    end

    context 'when updating mfa required fields' do
      let(:params) do
        { email: generate(:email) }
      end
      let(:current_user) { create(:user, :mfa_totp) }

      context 'when mfa is provided' do
        let(:otp) { ROTP::TOTP.new(current_user.totp_secret).now }
        let(:mfa) do
          { type: :totp, value: otp }
        end

        it { is_expected.to be_success }
        it { expect(service_response.payload.reload).to be_valid }

        it 'updates user' do
          expect { service_response }.to change {
            current_user.reload.email
          }.from(current_user.email).to(params[:email])
        end

        it do
          is_expected.to create_audit_event(
            :user_updated,
            author_id: current_user.id,
            entity_type: 'User',
            details: { email: params[:email], mfa_type: 'totp' },
            target_type: 'User'
          )
        end
      end

      context 'when mfa is not provided' do
        it 'requires mfa' do
          expect(service_response.payload).to eq(:mfa_required)
        end

        it { is_expected.not_to be_success }

        it 'does not update user' do
          expect { service_response }.not_to change { current_user.reload.username }
        end

        it do
          is_expected.not_to create_audit_event
        end
      end

      context 'when mfa is invalid' do
        let(:mfa) do
          { type: :totp, value: '123456' }
        end

        it 'fails' do
          expect(service_response.payload).to eq(:mfa_failed)
        end

        it { is_expected.not_to be_success }

        it 'does not update user' do
          expect { service_response }.not_to change { current_user.reload.email }
        end

        it do
          is_expected.not_to create_audit_event
        end
      end

      context 'when mfa is not activated and not provided' do
        let(:current_user) { create(:user) }

        it { is_expected.to be_success }
        it { expect(service_response.payload.reload).to be_valid }

        it 'updates user' do
          expect { service_response }.to change {
            current_user.reload.email
          }.from(current_user.email).to(params[:email])
        end

        it do
          is_expected.to create_audit_event(
            :user_updated,
            author_id: current_user.id,
            entity_type: 'User',
            details: { email: params[:email] },
            target_type: 'User'
          )
        end
      end
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it 'updates user' do
      expect { service_response }.to change {
        current_user.reload.username
      }.from(current_user.username).to(params[:username]).and change {
                                                                current_user.reload.password
                                                              }.from(current_user.password).to(params[:password])
    end

    it do
      is_expected.to create_audit_event(
        :user_updated,
        author_id: current_user.id,
        entity_type: 'User',
        details: { username: params[:username] },
        target_type: 'User'
      )
    end
  end
end
