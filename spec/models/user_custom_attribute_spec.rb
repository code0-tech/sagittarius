# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserCustomAttribute do
  subject(:custom_attribute) { create(:user_custom_attribute) }

  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:user_custom_attributes).required }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_length_of(:key).is_at_most(255) }
    it { is_expected.to validate_uniqueness_of(:key).scoped_to(:user_id) }

    describe 'value' do
      it 'is invalid when nil' do
        custom_attribute.value = nil
        is_expected.not_to be_valid
      end

      it 'is valid when false' do
        custom_attribute.value = false
        is_expected.to be_valid
      end

      it 'is valid when an empty hash' do
        custom_attribute.value = {}
        is_expected.to be_valid
      end
    end
  end
end
