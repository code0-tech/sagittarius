# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team do
  subject { create(:team) }

  describe 'associations' do
    it { is_expected.to have_many(:team_members).inverse_of(:team) }
    it { is_expected.to have_many(:users).through(:team_members).inverse_of(:teams) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
  end
end
