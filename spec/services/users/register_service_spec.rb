# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegisterService do
  subject(:service_response) { described_class.new(username, email, password).execute }

  context 'when user is valid' do
    let(:username) { generate(:username) }
    let(:email) { generate(:email) }
    let(:password) { generate(:password) }

    it_behaves_like 'sends an email' do
      let(:token) { SecureRandom.base64(10) }
      before do
        # rubocop:disable RSpec/AnyInstance -- No other way to mock this
        allow_any_instance_of(User).to receive(:generate_token_for).with(:email_verification).and_return(token)
        # rubocop:enable RSpec/AnyInstance
      end

      let(:mailer_class) { UserMailer }
      let(:mail_method) { :email_verification }
      let(:mail_params) { { verification_code: token, user: instance_of(User) } }
    end

    it { is_expected.to be_success }

    it do
      expect(service_response.payload).to be_valid
      expect(service_response.payload).to be_a(UserSession)
      expect(service_response.payload.user.id).to be_present
      expect(service_response.payload.token).to be_present
    end

    it('sets username correct') { expect(service_response.payload.user.username).to eq(username) }
    it('sets email correct') { expect(service_response.payload.user.email).to eq(email) }
    it('sets password correct') { expect(service_response.payload.user.password).to eq(password) }

    it 'creates the audit event' do
      expect { service_response }.to create_audit_event(
        :user_registered,
        entity_type: 'User',
        details: { username: username, email: email },
        target_type: 'User'
      )
    end

    context 'when user registration is disabled' do
      before do
        stub_application_settings(user_registration_enabled: false)
      end

      it { is_expected.not_to be_success }
      it { expect(service_response.message).to eq('User registration is disabled') }
      it { expect(service_response.payload).to eq(:registration_disabled) }
    end
  end

  shared_examples 'invalid user' do
    it { is_expected.not_to be_success }
    it { expect(service_response.message).to eq('User is invalid') }
    it { expect { service_response }.not_to create_audit_event }

    it_behaves_like 'sends no email' do
      let(:token) { SecureRandom.base64(10) }
      before do
        # rubocop:disable RSpec/AnyInstance -- No other way to mock this
        allow_any_instance_of(User).to receive(:generate_token_for).with(:email_verification).and_return(token)
        # rubocop:enable RSpec/AnyInstance
      end

      let(:mailer_class) { UserMailer }
      let(:mail_method) { :email_verification }
      let(:mail_params) { { verification_code: token, user: instance_of(User) } }
    end
  end

  context 'when user is invalid' do
    let!(:user_with_username) { create(:user, username: 'user') }
    let!(:user_with_email) { create(:user, email: 'test@code0.tech') }

    context 'when username is duplicated' do
      let(:username) { user_with_username.username }
      let(:email) { generate(:email) }
      let(:password) { generate(:password) }

      it_behaves_like 'invalid user'
      it { expect(service_response.payload.full_messages).to include('Username has already been taken') }
    end

    context 'when email is duplicated' do
      let(:username) { generate(:username) }
      let(:email) { user_with_email.email }
      let(:password) { generate(:password) }

      it_behaves_like 'invalid user'
      it { expect(service_response.payload.full_messages).to include('Email has already been taken') }
    end
  end

  context 'when invalid inputs are given' do
    context 'when username is nil' do
      let(:username) { nil }
      let(:email) { generate(:email) }
      let(:password) { generate(:password) }

      it_behaves_like 'invalid user'
      it { expect(service_response.payload.full_messages).to include("Username can't be blank") }
    end

    context 'when email is nil' do
      let(:username) { generate(:username) }
      let(:email) { nil }
      let(:password) { generate(:password) }

      it_behaves_like 'invalid user'
      it { expect(service_response.payload.full_messages).to include("Email can't be blank") }
    end

    context 'when password is nil' do
      let(:username) { generate(:username) }
      let(:email) { generate(:email) }
      let(:password) { nil }

      it_behaves_like 'invalid user'
      it { expect(service_response.payload.full_messages).to include("Password can't be blank") }
    end
  end
end
