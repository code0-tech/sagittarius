# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserNamespacePinPolicy do
  subject { described_class.new(create_authentication(current_user), user_namespace_pin) }

  let(:user_namespace_pin) { create(:user_namespace_pin) }

  context 'when user is the owner of the pin' do
    let(:current_user) { user_namespace_pin.user }

    it { is_expected.to be_allowed(:read_user_namespace_pin) }
  end

  context 'when user is not the owner of the pin' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_allowed(:read_user_namespace_pin) }
  end

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_allowed(:read_user_namespace_pin) }
  end
end
