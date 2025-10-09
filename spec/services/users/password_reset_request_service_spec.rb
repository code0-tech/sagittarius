# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::PasswordResetRequestService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), current_user).execute
  end

  let(:current_user) { create(:user) }

  shared_examples 'user doesnt verify' do
    it { is_expected.to be_error }

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }

    it_behaves_like 'user doesnt verify'
  end

  context 'when user and params are valid' do
    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it do
      is_expected.to create_audit_event(
        :password_reset_requested,
        author_id: current_user.id,
        entity_type: 'User',
        details: {},
        target_type: 'User'
      )
    end

    it_behaves_like 'sends an email' do
      let(:token) { SecureRandom.base64(10) }
      before do
        # rubocop:disable RSpec/AnyInstance -- No other way to mock this
        allow_any_instance_of(User).to receive(:generate_token_for).with(:password_reset).and_return(token)
        # rubocop:enable RSpec/AnyInstance
      end

      let(:mailer_class) { UserMailer }
      let(:mail_method) { :password_reset }
      let(:mail_params) { { verification_code: token, user: instance_of(User) } }
    end
  end
end
