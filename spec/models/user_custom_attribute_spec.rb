# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserCustomAttribute do
  subject { create(:user_custom_attribute) }

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:user_custom_attributes).required }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_length_of(:key).is_at_most(255) }
    it { is_expected.to validate_uniqueness_of(:key).scoped_to(:user_id) }
    it { is_expected.to validate_presence_of(:value) }
  end
end
