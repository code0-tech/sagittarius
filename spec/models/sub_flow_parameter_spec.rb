# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubFlowParameter do
  subject { create(:sub_flow_parameter) }

  describe 'associations' do
    it { is_expected.to belong_to(:parent_sub_flow).class_name('SubFlow').inverse_of(:sub_flow_parameters) }
    it { is_expected.to have_many(:inline_reference_values).inverse_of(:sub_flow_parameter) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:identifier) }
  end

  describe '#to_grpc' do
    it 'serializes the identifier, cast and a literal value' do
      parameter = create(:sub_flow_parameter, identifier: 'greeting', cast: 'STRING', literal_value: 'hello')

      grpc = parameter.to_grpc

      expect(grpc.identifier).to eq('greeting')
      expect(grpc.cast).to eq('STRING')
      expect(grpc.value.literal_value.value.to_ruby).to eq('hello')
    end
  end
end
