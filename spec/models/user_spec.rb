# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject { create(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:team_members).inverse_of(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }

    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.to validate_length_of(:username).is_at_most(50) }
  end
end
