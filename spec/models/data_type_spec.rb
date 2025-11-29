# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataType do
  subject(:data_type) { create(:data_type) }

  describe 'associations' do
    it { is_expected.to belong_to(:parent_type).class_name('DataTypeIdentifier').inverse_of(:child_types).optional }
    it { is_expected.to belong_to(:runtime).inverse_of(:data_types) }
    it { is_expected.to have_many(:names).class_name('Translation') }
    it { is_expected.to have_many(:aliases).class_name('Translation') }
    it { is_expected.to have_many(:display_messages).class_name('Translation') }
    it { is_expected.to have_many(:rules).class_name('DataTypeRule').inverse_of(:data_type) }
  end

  describe 'validations' do
    it { is_expected.to allow_values(*described_class::VARIANTS.keys).for(:variant) }

    context 'when generic keys are too long' do
      let(:data_type) { build(:data_type, generic_keys: Array.new(31, 'a' * 51)) } # 31 keys, each 51 characters long

      it 'is expected to be invalid' do
        expect(data_type).not_to be_valid
        expect(data_type.errors[:generic_keys]).to include('each key must be 50 characters or fewer')
        expect(data_type.errors[:generic_keys]).to include('must be 30 or fewer')
      end
    end

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

    describe '#validate_version' do
      it 'adds an error if version is blank' do
        data_type.version = ''
        data_type.validate_version
        expect(data_type.errors.added?(:version, :blank)).to be(true)
      end

      it 'adds an error if version is invalid' do
        data_type.version = 'invalid_version'
        data_type.validate_version
        expect(data_type.errors.added?(:version, :invalid)).to be(true)
      end

      it 'does not add an error if version is valid' do
        data_type.version = '1.0.0'
        data_type.validate_version
        expect(data_type.errors[:version]).to be_empty
      end
    end
  end
end
