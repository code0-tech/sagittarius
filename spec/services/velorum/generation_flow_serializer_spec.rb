# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Velorum::GenerationFlowSerializer do
  it 'serializes a generated flow into frontend-consumable JSON data' do
    flow = Tucana::Shared::GenerationFlow.new(
      name: 'Generated flow',
      type: 'default',
      node_functions: [
        Tucana::Shared::NodeFunction.new(
          runtime_function_id: 'sum',
          parameters: [
            Tucana::Shared::NodeParameter.new(
              runtime_parameter_id: 'left',
              value: Tucana::Shared::NodeValue.new(literal_value: Tucana::Shared::Value.from_ruby(1))
            )
          ]
        )
      ]
    )

    expect(described_class.new(flow).to_h).to include(
      name: 'Generated flow',
      type: 'default',
      starting_node_id: 'generated-1',
      nodes: [
        a_hash_including(
          id: 'generated-1',
          function_identifier: 'sum',
          parameters: [
            a_hash_including(
              id: 'generated-parameter-1-1',
              parameter_identifier: 'left',
              value: { literal_value: 1 }
            )
          ]
        )
      ]
    )
  end

  it 'maps generated node IDs into references and inferred next-node links' do
    flow = Tucana::Shared::GenerationFlow.new(
      name: 'Generated flow',
      type: 'default',
      node_functions: [
        Tucana::Shared::NodeFunction.new(
          runtime_function_id: 'input',
          parameters: []
        ),
        Tucana::Shared::NodeFunction.new(
          runtime_function_id: 'output',
          parameters: [
            Tucana::Shared::NodeParameter.new(
              runtime_parameter_id: 'value',
              value: Tucana::Shared::NodeValue.new(
                reference_value: Tucana::Shared::ReferenceValue.new(
                  node_id: 0,
                  paths: [Tucana::Shared::ReferencePath.new(path: 'result')]
                )
              )
            )
          ]
        )
      ]
    )

    serialized = described_class.new(flow).to_h

    expect(serialized[:nodes][0]).to include(id: 'generated-1', next_node_id: 'generated-2')
    expect(serialized[:nodes][1]).to include(id: 'generated-2', next_node_id: nil)
    expect(serialized.dig(:nodes, 1, :parameters, 0, :value, :reference_value)).to include(
      node_function_id: nil,
      reference_path: [{ path: 'result', array_index: nil }]
    )
  end
end
