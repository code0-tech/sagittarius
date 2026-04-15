# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NodeParameter do
  subject do
    create(:node_parameter)
  end

  describe 'associations' do
    it { is_expected.to belong_to(:parameter_definition).class_name('ParameterDefinition') }
    it { is_expected.to have_one(:reference_value) }

    it do
      is_expected.to have_one(:function_value)
        .class_name('NodeFunction')
        .inverse_of(:value_of_node_parameter)
    end

    it { is_expected.to belong_to(:node_function).class_name('NodeFunction').inverse_of(:node_parameters) }
  end

  describe 'validations' do
    it 'validates only one of the value fields is present' do
      param = build(
        :node_parameter,
        literal_value: 1,
        reference_value: create(:reference_value),
        function_value: nil
      )
      expect(param).not_to be_valid
      expect(param.errors[:value])
        .to include('Only one of literal_value, reference_value, or function_value must be present')
    end

    it 'allows all values to be empty' do
      param = build(
        :node_parameter,
        literal_value: nil,
        reference_value: nil,
        function_value: nil
      )
      expect(param).to be_valid
    end
  end
end
