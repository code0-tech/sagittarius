# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserOrganizationPin do
  subject { create(:user_organization_pin) }

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:user_organization_pins) }
    it { is_expected.to belong_to(:organization).inverse_of(:user_organization_pins) }
  end

  describe 'validations' do
    it { is_expected.to validate_numericality_of(:priority).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_uniqueness_of(:organization_id).scoped_to(:user_id) }
    it { is_expected.to validate_uniqueness_of(:priority).scoped_to(:user_id) }
  end
end
