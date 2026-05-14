# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeModule do
  subject(:runtime_module) { create(:runtime_module) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime).inverse_of(:runtime_modules) }
    it { is_expected.to have_many(:data_types).inverse_of(:runtime_module) }
    it { is_expected.to have_many(:runtime_flow_types).inverse_of(:runtime_module) }
    it { is_expected.to have_many(:flow_types).inverse_of(:runtime_module) }
    it { is_expected.to have_many(:runtime_function_definitions).inverse_of(:runtime_module) }
    it { is_expected.to have_many(:function_definitions).through(:runtime_function_definitions) }
    it { is_expected.to have_many(:module_configuration_definitions).inverse_of(:runtime_module) }
    it { is_expected.to have_many(:names).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:descriptions).class_name('Translation').inverse_of(:owner) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_uniqueness_of(:identifier).case_insensitive.scoped_to(:runtime_id) }
    it { is_expected.to validate_length_of(:identifier).is_at_most(50) }
    it { is_expected.to validate_length_of(:documentation).is_at_most(2000) }
    it { is_expected.to validate_length_of(:author).is_at_most(200) }
    it { is_expected.to validate_length_of(:icon).is_at_most(100) }

    describe '#validate_version' do
      it 'adds an error if version is blank' do
        runtime_module.version = ''
        runtime_module.validate_version
        expect(runtime_module.errors.added?(:version, :blank)).to be(true)
      end

      it 'adds an error if version is invalid' do
        runtime_module.version = 'invalid_version'
        runtime_module.validate_version
        expect(runtime_module.errors.added?(:version, :invalid)).to be(true)
      end

      it 'does not add an error if version is valid' do
        runtime_module.version = '1.0.0'
        runtime_module.validate_version
        expect(runtime_module.errors[:version]).to be_empty
      end
    end
  end
end
