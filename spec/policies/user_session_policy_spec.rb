# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSessionPolicy do
  subject { described_class.new(current_user, user_session) }

  let(:current_user) { nil }
  let(:user_session) { nil }

  context 'when user is owner of the session' do
    let(:current_user) { create(:user) }
    let(:user_session) { create(:user_session, user: current_user) }

    it { is_expected.to be_allowed(:logout_session) }
  end

  context 'when user is not owner of the session' do
    let(:current_user) { create(:user) }
    let(:user_session) { create(:user_session) }

    it { is_expected.not_to be_allowed(:logout_session) }
  end

  context 'when user is nil' do
    let(:current_user) { nil }
    let(:user_session) { create(:user_session) }

    it { is_expected.not_to be_allowed(:logout_session) }
  end
end
