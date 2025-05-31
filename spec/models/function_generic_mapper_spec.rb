# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FunctionGenericMapper do
  describe 'associations' do
    it { is_expected.to have_many(:source).class_name('DataTypeIdentifier').inverse_of(:function_generic_mapper) }
    it { is_expected.to belong_to(:runtime_parameter_definition).optional }

    it {
      is_expected.to belong_to(:runtime_function_definition).class_name('RuntimeFunctionDefinition')
                                                            .optional.inverse_of(:generic_mappers)
    }
  end
end
