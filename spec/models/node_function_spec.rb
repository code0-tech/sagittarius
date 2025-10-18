# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NodeFunction do
  subject { create(:node_function) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_function).class_name('RuntimeFunctionDefinition') }
    it { is_expected.to belong_to(:next_node).class_name('NodeFunction').optional }

    it { is_expected.to have_many(:node_parameter_values).inverse_of(:function_value) }
    it { is_expected.to have_many(:node_parameters).inverse_of(:node_function) }
  end

  describe '#resolve_flow' do
    let(:nodes) do
      runtime = create(:runtime)
      definition = create(:runtime_function_definition, runtime: runtime)
      node3 = create(:node_function, runtime_function: definition)
      node2 = create(:node_function, runtime_function: definition, next_node: node3)
      node1 = create(:node_function, runtime_function: definition, next_node: node2)
      [node1, node2, node3]
    end

    let!(:flow) { create(:flow, starting_node: nodes.first) }

    it 'returns the correct flow' do
      expect(nodes[0].resolve_flow).to eq(flow)
      expect(nodes[1].resolve_flow).to eq(flow)
      expect(nodes[2].resolve_flow).to eq(flow)
    end
  end
end
