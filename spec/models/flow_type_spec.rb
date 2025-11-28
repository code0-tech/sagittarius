# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowType do
  subject(:flow_type) { create(:flow_type) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime) }
    it { is_expected.to belong_to(:input_type).class_name('DataType').optional }
    it { is_expected.to belong_to(:return_type).class_name('DataType').optional }
    it { is_expected.to have_many(:flow_type_settings).inverse_of(:flow_type) }
    it { is_expected.to have_many(:aliases).class_name('Translation') }
    it { is_expected.to have_many(:display_messages).class_name('Translation') }
    it { is_expected.to have_many(:descriptions).class_name('Translation') }
    it { is_expected.to have_many(:documentations).class_name('Translation') }
    it { is_expected.to have_many(:names).class_name('Translation') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_uniqueness_of(:identifier).scoped_to(:runtime_id) }
    it { is_expected.to allow_values(true, false).for(:editable) }

    describe '#validate_version' do
      it 'adds an error if version is blank' do
        flow_type.version = ''
        flow_type.validate_version
        expect(flow_type.errors.added?(:version, :blank)).to be(true)
      end

      it 'adds an error if version is invalid' do
        flow_type.version = 'invalid_version'
        flow_type.validate_version
        expect(flow_type.errors.added?(:version, :invalid)).to be(true)
      end

      it 'does not add an error if version is valid' do
        flow_type.version = '1.0.0'
        flow_type.validate_version
        expect(flow_type.errors[:version]).to be_empty
      end
    end
  end
end
