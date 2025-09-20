# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeFunctionDefinition do
  subject(:function) { create(:runtime_function_definition) }

  describe 'validations' do
    it { is_expected.to have_many(:parameters).inverse_of(:runtime_function_definition) }

    it { is_expected.to validate_presence_of(:runtime_name) }
    it { is_expected.to validate_uniqueness_of(:runtime_name).case_insensitive.scoped_to(:runtime_id) }
    it { is_expected.to validate_length_of(:runtime_name).is_at_most(50) }

    context 'when generic keys are too long' do
      before do
        function.generic_keys = Array.new(31, 'a' * 51) # 31 keys, each 51 characters long
      end

      it 'is expected to be invalid' do
        expect(function).not_to be_valid
        expect(function.errors[:generic_keys]).to include('each key must be 50 characters or fewer')
        expect(function.errors[:generic_keys]).to include('must be 30 or fewer')
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

    it { is_expected.to have_many(:names).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:descriptions).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:documentations).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:deprecation_messages).class_name('Translation').inverse_of(:owner) }
  end
end
