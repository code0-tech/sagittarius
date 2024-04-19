# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::LogoutService do
  subject(:service_response) { described_class.new(current_user, user_session).execute }

  context 'when current_user can log out user_session' do
    let(:current_user) { create(:user) }
    let(:user_session) { create(:user_session, user: current_user) }

    it { is_expected.to be_success }

    it 'changes the session to inactive' do
      expect { service_response }.to change { user_session.reload.active }.from(true).to(false)
    end
  end

  context 'when current_user can not log out user_session' do
    let(:current_user) { create(:user) }
    let(:user_session) { create(:user_session) }

    it { is_expected.not_to be_success }

    it 'does not change the session to inactive' do
      expect { service_response }.not_to change { user_session.reload.active }
    end
  end

  context 'when current_user is nil' do
    let(:current_user) { nil }
    let(:user_session) { create(:user_session) }

    it { is_expected.not_to be_success }

    it 'does not change the session to inactive' do
      expect { service_response }.not_to change { user_session.reload.active }
    end
  end
end
