# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class.new(create_authentication(current_user), user) }

  let(:user) { create(:user) }

  context 'when user is present' do
    let(:current_user) { create(:user) }

    it { is_expected.to be_allowed(:read_user) }
  end

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_allowed(:read_user) }
  end
end
