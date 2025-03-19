# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeFunctionDefinition do
  subject { create(:runtime_function_definition) }

  describe 'validations' do
    it { is_expected.to have_many(:parameters).inverse_of(:runtime_function_definition) }

    it { is_expected.to validate_presence_of(:runtime_name) }
    it { is_expected.to validate_uniqueness_of(:runtime_name).case_insensitive.scoped_to(:namespace_id) }
    it { is_expected.to validate_length_of(:runtime_name).is_at_most(50) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:namespace) }

    it do
      is_expected.to have_many(:parameters)
        .class_name('RuntimeParameterDefinition')
        .inverse_of(:runtime_function_definition)
    end

    it { is_expected.to have_many(:names).class_name('Translation').inverse_of(:owner) }
  end
end
