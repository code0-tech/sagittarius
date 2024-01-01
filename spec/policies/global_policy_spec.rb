# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GlobalPolicy do
  subject { described_class.new(current_user, nil) }

  context 'when user is present' do
    let(:current_user) { create(:user) }

    it { is_expected.to be_allowed(:create_team) }
  end

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_allowed(:create_team) }
  end
end
