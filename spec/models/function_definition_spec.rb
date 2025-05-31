# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FunctionDefinition do
  subject { create(:function_definition) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_function_definition) }
    it { is_expected.to belong_to(:return_type).class_name('DataTypeIdentifier').optional }
    it { is_expected.to have_many(:names).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:descriptions).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:documentations).class_name('Translation').inverse_of(:owner) }

    it {
      is_expected.to have_many(:generic_combination_strategies)
        .class_name('GenericCombinationStrategy').inverse_of(:function_generic_mapper)
    }
  end
end
