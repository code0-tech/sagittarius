# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationProject do
  subject { create(:organization_project) }

  describe 'associations' do
    it { is_expected.to belong_to(:organization).required }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_length_of(:description).is_at_most(500) }
    it { is_expected.to allow_value(' ').for(:description) }
    it { is_expected.to allow_value('').for(:description) }
  end
end
