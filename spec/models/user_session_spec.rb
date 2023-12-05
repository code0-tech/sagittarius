# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSession do
  subject { create(:user_session) }

  describe 'associations' do
    it { is_expected.to belong_to(:user).required }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_uniqueness_of(:token) }
  end
end
