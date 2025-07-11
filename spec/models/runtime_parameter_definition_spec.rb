# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeParameterDefinition do
  subject { create(:runtime_parameter_definition, data_type: create(:data_type_identifier, generic_key: 'T')) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:runtime_name) }

    it { is_expected.to have_many(:function_generic_mappers) }

    it {
      is_expected.to validate_uniqueness_of(:runtime_name).case_insensitive.scoped_to(:runtime_function_definition_id)
    }

    it { is_expected.to validate_length_of(:runtime_name).is_at_most(50) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_function_definition) }
    it { is_expected.to belong_to(:data_type).class_name('DataTypeIdentifier') }
    it { is_expected.to have_many(:parameter_definitions).inverse_of(:runtime_parameter_definition) }
    it { is_expected.to have_many(:names).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:descriptions).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:documentations).class_name('Translation').inverse_of(:owner) }
  end
end
