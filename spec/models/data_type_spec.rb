# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataType do
  subject { create(:data_type) }

  describe 'associations' do
    it { is_expected.to belong_to(:parent_type).class_name('DataTypeIdentifier').inverse_of(:child_types).optional }
    it { is_expected.to belong_to(:runtime).inverse_of(:data_types) }
    it { is_expected.to have_many(:names).class_name('Translation') }
    it { is_expected.to have_many(:rules).class_name('DataTypeRule').inverse_of(:data_type) }
  end

  describe 'validations' do
    it { is_expected.to allow_values(*described_class::VARIANTS.keys).for(:variant) }

    it 'detects recursions' do
      dt1 = create(:data_type)
      dt2 = create(:data_type, parent_type: create(:data_type_identifier, data_type: dt1))

      dt1.parent_type = create(:data_type_identifier, data_type: dt2)

      expect(dt1).not_to be_valid
      expect(dt1.errors.added?(:parent_type, :recursion)).to be(true)
    end

    it 'detects recursions over multiple levels' do
      dt1 = create(:data_type)
      dt2 = create(:data_type, parent_type: create(:data_type_identifier, data_type: dt1))
      dt3 = create(:data_type, parent_type: create(:data_type_identifier, data_type: dt2))
      dt4 = create(:data_type, parent_type: create(:data_type_identifier, data_type: dt3))

      dt1.parent_type = create(:data_type_identifier, data_type: dt4)

      expect(dt1.valid?).to be(false)
      expect(dt1.errors.added?(:parent_type, :recursion)).to be(true)
    end

    it 'detects direct recursions' do
      dt1 = create(:data_type)
      dt1.parent_type = create(:data_type_identifier, data_type: dt1)

      expect(dt1.valid?).to be(false)
      expect(dt1.errors.added?(:parent_type, :recursion)).to be(true)
    end
  end
end
