# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserOrganizationPinPolicy do
  subject { described_class.new(create_authentication(current_user), user_organization_pin) }

  let(:user_organization_pin) { create(:user_organization_pin) }

  context 'when user owns the pin' do
    let(:current_user) { user_organization_pin.user }

    it { is_expected.to be_allowed(:read_user_organization_pin) }
  end

  context 'when user does not own the pin' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_allowed(:read_user_organization_pin) }
  end

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_allowed(:read_user_organization_pin) }
  end
end
