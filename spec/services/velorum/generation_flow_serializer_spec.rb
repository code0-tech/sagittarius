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
      nodes: [
        a_hash_including(
          function_identifier: 'sum',
          parameters: [
            a_hash_including(
              parameter_identifier: 'left',
              value: { literal_value: 1 }
            )
          ]
        )
      ]
    )
  end
end
