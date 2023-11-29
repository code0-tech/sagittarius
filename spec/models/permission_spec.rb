# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permission do
  subject { create(:permission) }

  describe 'associations' do
    it { is_expected.to have_many(:policies).inverse_of(:permission) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
