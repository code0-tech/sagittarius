# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeFunctionDefinition do
  subject(:function) { create(:runtime_function_definition) }

  describe 'validations' do
    it { is_expected.to have_many(:parameters).inverse_of(:runtime_function_definition) }

    it { is_expected.to validate_presence_of(:runtime_name) }
    it { is_expected.to validate_uniqueness_of(:runtime_name).case_insensitive.scoped_to(:runtime_id) }
    it { is_expected.to validate_length_of(:runtime_name).is_at_most(50) }

    it { is_expected.to validate_presence_of(:signature) }
    it { is_expected.to validate_length_of(:signature).is_at_most(500) }

    describe '#validate_version' do
      it 'adds an error if version is blank' do
        function.version = ''
        function.validate_version
        expect(function.errors.added?(:version, :blank)).to be(true)
      end

      it 'adds an error if version is invalid' do
        function.version = 'invalid_version'
        function.validate_version
        expect(function.errors.added?(:version, :invalid)).to be(true)
      end

      it 'does not add an error if version is valid' do
        function.version = '1.0.0'
        function.validate_version
        expect(function.errors[:version]).to be_empty
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:runtime) }

    it do
      is_expected.to have_many(:parameters)
        .class_name('RuntimeParameterDefinition')
        .inverse_of(:runtime_function_definition)
    end

    it do
      is_expected.to have_many(:runtime_function_definition_data_type_links).inverse_of(:runtime_function_definition)
    end

    it do
      is_expected.to have_many(:referenced_data_types)
        .through(:runtime_function_definition_data_type_links)
        .source(:referenced_data_type)
    end

    it { is_expected.to have_many(:names).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:descriptions).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:documentations).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:deprecation_messages).class_name('Translation').inverse_of(:owner) }
  end
end
