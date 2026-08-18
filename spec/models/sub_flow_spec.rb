# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubFlow do
  subject { create(:sub_flow) }

  describe 'associations' do
    it { is_expected.to belong_to(:node_parameter).inverse_of(:sub_flow).optional }
    it { is_expected.to belong_to(:inline_reference_value).inverse_of(:sub_flow).optional }
    it { is_expected.to belong_to(:starting_node).class_name('NodeFunction').optional }
    it { is_expected.to belong_to(:function_definition).optional }
    it { is_expected.to have_many(:sub_flow_settings).inverse_of(:sub_flow) }
  end

  describe 'validations' do
    it 'requires exactly one execution reference' do
      sub_flow = build(:sub_flow, starting_node: nil, function_definition: nil)

      expect(sub_flow).not_to be_valid
      expect(sub_flow.errors[:base]).to include('Exactly one of starting_node or function_definition must be present')
    end

    it 'requires exactly one owner' do
      sub_flow = build(:sub_flow, node_parameter: nil, inline_reference_value: nil)

      expect(sub_flow).not_to be_valid
      expect(sub_flow.errors[:base])
        .to include('Exactly one of node_parameter or inline_reference_value must be present')
    end
  end

  describe '#to_grpc' do
    it 'serializes a function reference with its definition source' do
      runtime_function_definition = create(:runtime_function_definition, definition_source: 'taurus')
      function_definition = create(
        :function_definition,
        runtime: runtime_function_definition.runtime,
        runtime_function_definition: runtime_function_definition
      )
      sub_flow = create(:sub_flow, starting_node: nil, function_definition: function_definition)

      grpc_sub_flow = sub_flow.to_grpc

      expect(grpc_sub_flow.function).to have_attributes(
        function_identifier: function_definition.identifier,
        definition_source: 'taurus'
      )
      expect(grpc_sub_flow.function.has_definition_source?).to be(true)
    end
  end
end
