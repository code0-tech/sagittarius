# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NodeParameter do
  subject do
    create(:node_parameter,
           runtime_parameter: create(:runtime_parameter_definition,
                                     data_type: create(:data_type_identifier, data_type: create(:data_type))))
  end

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_parameter).class_name('RuntimeParameterDefinition') }
    it { is_expected.to belong_to(:reference_value).optional }
    it { is_expected.to belong_to(:function_value).class_name('NodeFunction').inverse_of(:node_parameter_values).optional }
    it { is_expected.to belong_to(:node_function).class_name('NodeFunction').inverse_of(:node_parameters) }
  end

  describe 'validations' do
    it 'validates only one of the value fields is present' do
      param = build(:node_parameter, literal_value: nil, reference_value: nil, function_value: nil,
                                     runtime_parameter: create(:runtime_parameter_definition,
                                                               data_type: create(:data_type_identifier,
                                                                                 data_type: create(:data_type))))
      expect(param).not_to be_valid
      expect(param.errors[:base])
        .to include('Exactly one of literal_value, reference_value, or function_value must be present')
    end
  end
end
