# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::ValidationService do
  subject(:service) { described_class.new(flow) }

  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project, primary_runtime: runtime) }
  let(:flow_type) { create(:flow_type, runtime: runtime) }
  let(:runtime_function_definition) do
    create(:runtime_function_definition, runtime: runtime, signature: '(arg: string): void')
  end
  let(:function_definition) do
    create(:function_definition, runtime_function_definition: runtime_function_definition).tap do |fd|
      rpd = create(
        :runtime_parameter_definition,
        runtime_function_definition: runtime_function_definition,
        runtime_name: 'arg'
      )
      create(:parameter_definition, runtime_parameter_definition: rpd, function_definition: fd)
    end
  end
  let(:node_function) do
    create(:node_function, function_definition: function_definition).tap do |nf|
      create(
        :node_parameter,
        parameter_definition: function_definition.parameter_definitions[0],
        node_function: nf,
        literal_value: '1'
      )
    end
  end
  let(:flow) do
    create(
      :flow,
      project: namespace_project,
      flow_type: flow_type,
      validation_status: :unvalidated,
      starting_node: node_function
    ).tap do |f|
      node_function.update!(flow: f)
    end
  end

  context 'with fixed validation results' do
    before do
      flow.update!(starting_node: node_function)
      allow(UpdateFlowForProjectJob).to receive(:perform_later)

      result = Triangulum::Validation::Result.new(valid?: valid, return_type: nil, diagnostics: diagnostics)
      allow(Triangulum::Validation).to receive(:new).and_return(
        instance_double(Triangulum::Validation, validate: result)
      )

      schema_result = Triangulum::FlowSchemaExtraction::Result.new(
        flow: Triangulum::FlowSchemaExtraction::SchematizedObject.new(
          input_schema: { 'type' => 'object' },
          output_schema: { 'type' => 'string' }
        ),
        subflow_parameters: [],
        subflow_references: []
      )
      allow(Triangulum::FlowSchemaExtraction).to receive(:new).and_return(
        instance_double(Triangulum::FlowSchemaExtraction, extract: schema_result)
      )
    end

    let(:diagnostics) { [] }

    context 'when validation passes' do
      let(:valid) { true }

      it 'sets validation status to valid' do
        service.execute

        expect(flow.reload.validation_status).to eq('valid')
      end

      it 'clears validation diagnostics' do
        service.execute

        expect(flow.reload.validation_diagnostics).to eq([])
      end

      it 'enqueues UpdateFlowForProjectJob' do
        service.execute

        expect(UpdateFlowForProjectJob).to have_received(:perform_later).with(flow.id)
      end

      it 'persists the extracted flow input and output schema' do
        service.execute

        expect(flow.reload).to have_attributes(
          input_schema: { 'type' => 'object' },
          output_schema: { 'type' => 'string' }
        )
      end

      context 'when the flow has a sub flow parameter' do
        let(:sub_flow_function_definition) do
          create(:function_definition, runtime_function_definition: create(:runtime_function_definition,
                                                                           runtime: runtime))
        end
        let(:sub_flow_node_function) do
          create(:node_function, function_definition: function_definition, flow: flow)
        end
        let(:node_parameter) do
          create(:node_parameter, parameter_definition: function_definition.parameter_definitions[0],
                                  node_function: sub_flow_node_function, literal_value: nil)
        end
        let!(:sub_flow) do
          create(:sub_flow, node_parameter: node_parameter, starting_node: nil,
                            function_definition: sub_flow_function_definition)
        end

        before do
          schema_result = Triangulum::FlowSchemaExtraction::Result.new(
            flow: Triangulum::FlowSchemaExtraction::SchematizedObject.new(
              input_schema: {},
              output_schema: {}
            ),
            subflow_parameters: [
              Triangulum::FlowSchemaExtraction::SchematizedObject.new(
                id: node_parameter.to_global_id.to_s,
                input_schema: { 'type' => 'sub-input' },
                output_schema: { 'type' => 'sub-output' }
              )
            ],
            subflow_references: []
          )
          allow(Triangulum::FlowSchemaExtraction).to receive(:new).and_return(
            instance_double(Triangulum::FlowSchemaExtraction, extract: schema_result)
          )
        end

        it 'persists the extracted schema onto the matching sub flow' do
          service.execute

          expect(sub_flow.reload).to have_attributes(
            input_schema: { 'type' => 'sub-input' },
            output_schema: { 'type' => 'sub-output' }
          )
        end
      end

      context 'when the flow has a sub flow reference' do
        let(:inline_reference_value) do
          create(:inline_reference_value, node_parameter: node_function.node_parameters.first)
        end
        let!(:sub_flow) do
          create(:sub_flow, node_parameter: nil, inline_reference_value: inline_reference_value,
                            starting_node: nil,
                            function_definition: create(:function_definition,
                                                        runtime_function_definition: create(
                                                          :runtime_function_definition, runtime: runtime
                                                        )))
        end

        before do
          schema_result = Triangulum::FlowSchemaExtraction::Result.new(
            flow: Triangulum::FlowSchemaExtraction::SchematizedObject.new(
              input_schema: {},
              output_schema: {}
            ),
            subflow_parameters: [],
            subflow_references: [
              Triangulum::FlowSchemaExtraction::SchematizedObject.new(
                id: inline_reference_value.to_global_id.to_s,
                input_schema: { 'type' => 'ref-input' },
                output_schema: { 'type' => 'ref-output' }
              )
            ]
          )
          allow(Triangulum::FlowSchemaExtraction).to receive(:new).and_return(
            instance_double(Triangulum::FlowSchemaExtraction, extract: schema_result)
          )
        end

        it 'persists the extracted schema onto the matching sub flow' do
          service.execute

          expect(sub_flow.reload).to have_attributes(
            input_schema: { 'type' => 'ref-input' },
            output_schema: { 'type' => 'ref-output' }
          )
        end
      end
    end

    context 'when validation fails' do
      let(:valid) { false }
      let(:diagnostics) do
        [
          Triangulum::Validation::Diagnostic.new(
            message: 'First validation failure',
            code: 1001,
            severity: 'error',
            node_id: 123,
            parameter_index: 0
          ),
          Triangulum::Validation::Diagnostic.new(
            message: 'Second validation failure',
            code: 1002,
            severity: 'warning',
            node_id: nil,
            parameter_index: nil
          )
        ]
      end

      it 'sets validation status to invalid' do
        service.execute

        expect(flow.reload.validation_status).to eq('invalid')
      end

      it 'does not extract or persist a schema' do
        service.execute

        expect(Triangulum::FlowSchemaExtraction).not_to have_received(:new)
        expect(flow.reload).to have_attributes(input_schema: nil, output_schema: nil)
      end

      it 'stores validation diagnostics' do
        service.execute

        expect(flow.reload.validation_diagnostics).to eq(
          [
            {
              'message' => 'First validation failure',
              'code' => 1001,
              'severity' => 'error',
              'node_id' => 123,
              'parameter_index' => 0,
            },
            {
              'message' => 'Second validation failure',
              'code' => 1002,
              'severity' => 'warning',
              'node_id' => nil,
              'parameter_index' => nil,
            }
          ]
        )
      end

      it 'does not enqueue a runtime update for a newly created invalid flow' do
        service.execute

        expect(UpdateFlowForProjectJob).not_to have_received(:perform_later)
      end

      it 'does not enqueue a deletion when a previously valid flow becomes invalid' do
        flow.update!(validation_status: :valid)

        service.execute

        expect(UpdateFlowForProjectJob).not_to have_received(:perform_later)
      end
    end
  end

  context 'when calling triangulum without mocking' do
    it 'sets validation status to valid' do
      result = service.execute

      expect(result).to have_attributes(valid?: true, diagnostics: [])
      expect(flow.reload.validation_status).to eq('valid')
    end

    it 'persists the extracted input and output schema onto the flow' do
      service.execute

      expect(flow.reload).to have_attributes(
        input_schema: { 'type' => 'object', 'additionalProperties' => false },
        output_schema: { 'not' => {} }
      )
    end

    context 'with a direct mapping sub flow' do
      let(:callback_runtime_function_definition) do
        create(:runtime_function_definition, runtime: runtime, signature: '(arg: () => string): void')
      end
      let(:callback_function_definition) do
        create(:function_definition, runtime_function_definition: callback_runtime_function_definition).tap do |fd|
          rpd = create(
            :runtime_parameter_definition,
            runtime_function_definition: callback_runtime_function_definition,
            runtime_name: 'arg'
          )
          create(:parameter_definition, runtime_parameter_definition: rpd, function_definition: fd)
        end
      end
      let(:callback_node_function) do
        create(:node_function, function_definition: callback_function_definition)
      end
      let(:sub_flow_runtime_function_definition) do
        create(:runtime_function_definition, runtime: runtime, signature: '(): string')
      end
      let(:sub_flow_function_definition) do
        create(:function_definition, runtime_function_definition: sub_flow_runtime_function_definition)
      end
      let(:flow) do
        create(
          :flow,
          project: namespace_project,
          flow_type: flow_type,
          validation_status: :unvalidated,
          starting_node: callback_node_function
        ).tap do |f|
          callback_node_function.update!(flow: f)
        end
      end
      let!(:sub_flow) do
        node_parameter = create(
          :node_parameter,
          parameter_definition: callback_function_definition.parameter_definitions[0],
          node_function: callback_node_function,
          literal_value: nil
        )
        create(
          :sub_flow,
          node_parameter: node_parameter,
          starting_node: nil,
          function_definition: sub_flow_function_definition,
          signature: '(): string'
        )
      end

      it 'includes the sub flow function definition and sets validation status to valid' do
        result = service.execute

        expect(result).to have_attributes(valid?: true, diagnostics: [])
        expect(flow.reload.validation_status).to eq('valid')
      end

      it 'persists the extracted input and output schema onto the sub flow' do
        service.execute

        expect(sub_flow.reload).to have_attributes(
          input_schema: { 'type' => 'object', 'additionalProperties' => false },
          output_schema: { 'type' => 'string' }
        )
      end
    end

    context 'with an inline reference sub flow' do
      # The top-level function takes a list of callables; the only way to fill it
      # is a literal list carrying an inline reference whose value is a sub flow.
      # Triangulum reports such a sub flow under `subflow_references`, keyed by the
      # inline reference value's database id.
      let(:tools_runtime_function_definition) do
        create(:runtime_function_definition, runtime: runtime, signature: '(tools: Array<() => string>): void')
      end
      let(:tools_function_definition) do
        create(:function_definition, runtime_function_definition: tools_runtime_function_definition).tap do |fd|
          rpd = create(
            :runtime_parameter_definition,
            runtime_function_definition: tools_runtime_function_definition,
            runtime_name: 'tools'
          )
          create(:parameter_definition, runtime_parameter_definition: rpd, function_definition: fd)
        end
      end
      let(:tools_node_function) do
        create(:node_function, function_definition: tools_function_definition)
      end
      let(:sub_flow_runtime_function_definition) do
        create(:runtime_function_definition, runtime: runtime, signature: '(): string')
      end
      let(:sub_flow_function_definition) do
        create(:function_definition, runtime_function_definition: sub_flow_runtime_function_definition)
      end
      let(:flow) do
        create(
          :flow,
          project: namespace_project,
          flow_type: flow_type,
          validation_status: :unvalidated,
          starting_node: tools_node_function
        ).tap do |f|
          tools_node_function.update!(flow: f)
        end
      end
      let(:inline_reference_value) do
        node_parameter = create(
          :node_parameter,
          parameter_definition: tools_function_definition.parameter_definitions[0],
          node_function: tools_node_function,
          literal_value: ['${item_0}']
        )
        create(:inline_reference_value, node_parameter: node_parameter, signature: 'item_0', literal_value: nil)
      end
      let!(:sub_flow) do
        create(
          :sub_flow,
          node_parameter: nil,
          inline_reference_value: inline_reference_value,
          starting_node: nil,
          function_definition: sub_flow_function_definition,
          signature: '(): string'
        )
      end

      it 'sets validation status to valid' do
        result = service.execute

        expect(result).to have_attributes(valid?: true, diagnostics: [])
        expect(flow.reload.validation_status).to eq('valid')
      end

      it 'persists the extracted input and output schema onto the sub flow' do
        service.execute

        expect(sub_flow.reload).to have_attributes(
          input_schema: { 'type' => 'object', 'additionalProperties' => false },
          output_schema: { 'type' => 'string' }
        )
      end
    end
  end
end
