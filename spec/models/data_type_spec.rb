# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataType do
  subject(:data_type) { create(:data_type) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime).inverse_of(:data_types) }
    it { is_expected.to have_many(:names).class_name('Translation') }
    it { is_expected.to have_many(:aliases).class_name('Translation') }
    it { is_expected.to have_many(:display_messages).class_name('Translation') }
    it { is_expected.to have_many(:rules).class_name('DataTypeRule').inverse_of(:data_type) }
    it { is_expected.to have_many(:data_type_data_type_links).inverse_of(:data_type) }

    it do
      is_expected.to have_many(:referenced_data_types).through(:data_type_data_type_links).source(:referenced_data_type)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_length_of(:type).is_at_most(2000) }

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
