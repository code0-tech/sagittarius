# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataType do
  subject { create(:data_type) }

  describe 'associations' do
    it { is_expected.to belong_to(:parent_type).class_name('DataType').inverse_of(:child_types).optional }
    it { is_expected.to have_many(:child_types).class_name('DataType').inverse_of(:parent_type) }
    it { is_expected.to have_many(:translations).class_name('Translation') }
    it { is_expected.to have_many(:rules).class_name('DataTypeRule').inverse_of(:data_type) }
  end

  describe 'validations' do
    it { is_expected.to allow_values(*described_class::VARIANTS.keys).for(:variant) }
  end
end
