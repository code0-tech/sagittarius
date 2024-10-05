# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserIdentity do
  subject { create(:user_identity) }

  describe 'associations' do
    it { is_expected.to belong_to(:user).required }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:provider_id) }
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_uniqueness_of(:identifier).scoped_to(:provider_id) }
    it { is_expected.to validate_uniqueness_of(:provider_id).scoped_to(:user_id) }
  end
end
