# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Velorum::GenerationFlowSerializer do
  let(:runtime) { create(:runtime) }
  let(:project) { create(:namespace_project, primary_runtime: runtime) }
  let(:flow_type) { create(:flow_type, runtime: runtime, identifier: 'default') }

  it 'serializes a generated flow into frontend-consumable JSON data' do
    flow_type_setting = create(:flow_type_setting, flow_type: flow_type, identifier: 'region')
    runtime_function_definition = create(:runtime_function_definition, runtime: runtime, runtime_name: 'sum')
    function_definition = create(
      :function_definition,
      runtime: runtime,
      runtime_function_definition: runtime_function_definition,
      identifier: 'sum-function'
    )
    first_runtime_parameter = create(
      :runtime_parameter_definition,
      runtime_function_definition: runtime_function_definition,
      runtime_name: 'left'
    )
    second_runtime_parameter = create(
      :runtime_parameter_definition,
      runtime_function_definition: runtime_function_definition,
      runtime_name: 'right'
    )
    create(
      :parameter_definition,
      function_definition: function_definition,
      runtime_parameter_definition: second_runtime_parameter
    )
    first_parameter_definition = create(
      :parameter_definition,
      function_definition: function_definition,
      runtime_parameter_definition: first_runtime_parameter
    )
    flow = Tucana::Shared::GenerationFlow.new(
      name: 'Generated flow',
      type: 'default',
      settings: [
        Tucana::Shared::FlowSetting.new(
          flow_setting_id: 'setting_0',
          value: Tucana::Shared::Value.from_ruby('eu')
        )
      ],
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

    expect(described_class.new(flow, project: project).to_h).to include(
      name: 'Generated flow',
      type: flow_type,
      starting_node_id: 'generated-1',
      settings: [
        a_hash_including(
          id: 1,
          flow_setting_identifier: 'region',
          flow_type_setting: flow_type_setting,
          value: 'eu',
          cast: nil
        )
      ],
      nodes: [
        a_hash_including(
          id: 'generated-1',
          function_definition: function_definition,
          parameters: [
            a_hash_including(
              id: 1,
              parameter_definition: first_parameter_definition,
              value: {
                generated_value_type: :literal_value,
                value: 1,
              }
            )
          ]
        )
      ]
    )
  end

  it 'resolves generated flow types by runtime identifier' do
    runtime_flow_type = create(:runtime_flow_type, runtime: runtime, identifier: 'REST')
    flow_type = create(
      :flow_type,
      runtime: runtime,
      runtime_flow_type: runtime_flow_type,
      identifier: 'rest-endpoint'
    )
    flow = Tucana::Shared::GenerationFlow.new(
      name: 'Generated REST flow',
      type: 'REST'
    )

    expect(described_class.new(flow, project: project).to_h).to include(
      name: 'Generated REST flow',
      type: flow_type
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
    expect(serialized.dig(:nodes, 1, :parameters, 0, :value)).to include(
      generated_value_type: :reference_value,
      id: 1,
      node_function_id: nil,
      reference_path: [
        include(path: 'result', array_index: nil)
      ]
    )
  end

  it 'maps gRPC reference variants and sub-flow values to flow-shaped objects' do
    flow = Tucana::Shared::GenerationFlow.new(
      node_functions: [
        Tucana::Shared::NodeFunction.new(
          database_id: 10,
          runtime_function_id: 'output',
          parameters: [
            Tucana::Shared::NodeParameter.new(
              database_id: 20,
              runtime_parameter_id: 'flow-input',
              value: Tucana::Shared::NodeValue.new(
                reference_value: Tucana::Shared::ReferenceValue.new(
                  flow_input: Tucana::Shared::FlowInput.new,
                  paths: [Tucana::Shared::ReferencePath.new(path: 'input')]
                )
              )
            ),
            Tucana::Shared::NodeParameter.new(
              runtime_parameter_id: 'input-type',
              value: Tucana::Shared::NodeValue.new(
                reference_value: Tucana::Shared::ReferenceValue.new(
                  input_type: Tucana::Shared::InputType.new(
                    node_id: 10,
                    parameter_index: 1,
                    input_index: 2
                  )
                )
              )
            ),
            Tucana::Shared::NodeParameter.new(
              runtime_parameter_id: 'sub-flow',
              value: Tucana::Shared::NodeValue.new(
                sub_flow: Tucana::Shared::SubFlow.new(
                  function_identifier: 'helper',
                  signature: '(): undefined'
                )
              )
            )
          ]
        )
      ]
    )

    serialized = described_class.new(flow).to_h

    expect(serialized).not_to have_key(:node_functions)
    expect(serialized.dig(:nodes, 0)).to include(id: '10')
    expect(serialized.dig(:nodes, 0, :parameters, 0)).to include(id: 20)
    expect(serialized.dig(:nodes, 0, :parameters, 0, :value)).to include(
      generated_value_type: :reference_value,
      id: 20,
      node_function_id: nil,
      reference_path: [
        include(path: 'input', array_index: nil)
      ]
    )
    expect(serialized.dig(:nodes, 0, :parameters, 1, :value)).to include(
      generated_value_type: :reference_value,
      id: 1,
      node_function_id: '10',
      parameter_index: 1,
      input_index: 2
    )
    expect(serialized.dig(:nodes, 0, :parameters, 2, :value)).to include(
      generated_value_type: :sub_flow_value,
      starting_node_id: nil,
      function_definition: nil,
      signature: '(): undefined',
      settings: []
    )
  end

  it 'resolves generated sub-flow function identifiers to function definitions' do
    runtime_function_definition = create(:runtime_function_definition, runtime: runtime, runtime_name: 'helper')
    function_definition = create(
      :function_definition,
      runtime: runtime,
      runtime_function_definition: runtime_function_definition,
      identifier: 'helper-function'
    )
    runtime_parameter_definition = create(
      :runtime_parameter_definition,
      runtime_function_definition: runtime_function_definition
    )
    create(
      :parameter_definition,
      function_definition: function_definition,
      runtime_parameter_definition: runtime_parameter_definition
    )
    flow_type
    flow = Tucana::Shared::GenerationFlow.new(
      type: 'default',
      node_functions: [
        Tucana::Shared::NodeFunction.new(
          runtime_function_id: 'helper',
          parameters: [
            Tucana::Shared::NodeParameter.new(
              value: Tucana::Shared::NodeValue.new(
                sub_flow: Tucana::Shared::SubFlow.new(function_identifier: 'helper')
              )
            )
          ]
        )
      ]
    )

    serialized = described_class.new(flow, project: project).to_h

    expect(serialized.dig(:nodes, 0, :parameters, 0, :value)).to include(
      generated_value_type: :sub_flow_value,
      function_definition: function_definition
    )
  end
end
