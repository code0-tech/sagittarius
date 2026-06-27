# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization do
  subject { create(:organization) }

  describe 'associations' do
    it { is_expected.to have_many(:user_organization_pins).inverse_of(:organization) }
    it { is_expected.to have_many(:pinned_by_users).through(:user_organization_pins).source(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
  end
end
