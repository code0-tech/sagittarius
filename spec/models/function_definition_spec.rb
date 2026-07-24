# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FunctionDefinition do
  subject { create(:function_definition) }

  describe 'validations' do
    it { is_expected.to validate_length_of(:design).is_at_most(200) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:runtime).inverse_of(:function_definitions) }
    it { is_expected.to belong_to(:runtime_module).inverse_of(:function_definitions) }
    it { is_expected.to belong_to(:runtime_function_definition) }
    it { is_expected.to have_many(:names).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:descriptions).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:documentations).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:deprecation_messages).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:aliases).class_name('Translation') }
    it { is_expected.to have_many(:display_messages).class_name('Translation') }
  end

  describe '#ordered_parameter_definitions' do
    let(:runtime_function_definition) { create(:runtime_function_definition) }
    let(:function_definition) do
      create(:function_definition, runtime_function_definition: runtime_function_definition)
    end

    it 'orders parameter definitions by runtime parameter definition order' do
      first_runtime_parameter = create(
        :runtime_parameter_definition,
        runtime_function_definition: runtime_function_definition,
        runtime_name: 'first'
      )
      second_runtime_parameter = create(
        :runtime_parameter_definition,
        runtime_function_definition: runtime_function_definition,
        runtime_name: 'second'
      )

      second_parameter = create(
        :parameter_definition,
        function_definition: function_definition,
        runtime_parameter_definition: second_runtime_parameter
      )
      first_parameter = create(
        :parameter_definition,
        function_definition: function_definition,
        runtime_parameter_definition: first_runtime_parameter
      )

      expect(function_definition.ordered_parameter_definitions).to eq([first_parameter, second_parameter])
    end
  end
end
