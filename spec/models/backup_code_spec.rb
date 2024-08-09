# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BackupCode do
  subject { create(:backup_code) }

  describe 'associations' do
    it { is_expected.to belong_to(:user).class_name('User').inverse_of(:backup_codes).required }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_uniqueness_of(:token).case_insensitive.scoped_to(:user_id) }
    it { is_expected.to validate_length_of(:token).is_at_most(10).is_at_least(10) }
  end
end
