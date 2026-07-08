# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::ValidationService do
  subject(:service) { described_class.new(flow) }

  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project) }
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
      allow(UpdateRuntimesForProjectJob).to receive(:perform_later)

      result = Triangulum::Validation::Result.new(valid?: valid, return_type: nil, diagnostics: [])
      allow(Triangulum::Validation).to receive(:new).and_return(
        instance_double(Triangulum::Validation, validate: result)
      )
    end

    context 'when validation passes' do
      let(:valid) { true }

      it 'sets validation status to valid' do
        service.execute

        expect(flow.reload.validation_status).to eq('valid')
      end

      it 'enqueues UpdateRuntimesForProjectJob' do
        service.execute

        expect(UpdateRuntimesForProjectJob).to have_received(:perform_later).with(namespace_project.id)
      end
    end

    context 'when validation fails' do
      let(:valid) { false }

      it 'sets validation status to invalid' do
        service.execute

        expect(flow.reload.validation_status).to eq('invalid')
      end

      it 'enqueues UpdateRuntimesForProjectJob' do
        service.execute

        expect(UpdateRuntimesForProjectJob).to have_received(:perform_later).with(namespace_project.id)
      end
    end
  end

  context 'when calling triangulum without mocking' do
    it 'sets validation status to valid' do
      result = service.execute

      expect(result).to have_attributes(valid?: true, diagnostics: [])
      expect(flow.reload.validation_status).to eq('valid')
    end
  end

  context 'with unordered parameter records' do
    let(:runtime_function_definition) do
      create(:runtime_function_definition, runtime: runtime, signature: '(first: string, second: string): void')
    end

    let(:function_definition) do
      create(:function_definition, runtime_function_definition: runtime_function_definition).tap do |fd|
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

        create(:parameter_definition, runtime_parameter_definition: second_runtime_parameter, function_definition: fd)
        create(:parameter_definition, runtime_parameter_definition: first_runtime_parameter, function_definition: fd)
      end
    end

    let(:node_function) do
      create(:node_function, function_definition: function_definition).tap do |nf|
        create(
          :node_parameter,
          parameter_definition: function_definition.ordered_parameter_definitions.second,
          node_function: nf,
          literal_value: '2'
        )
        create(
          :node_parameter,
          parameter_definition: function_definition.ordered_parameter_definitions.first,
          node_function: nf,
          literal_value: '1'
        )
      end
    end

    it 'passes parameters to triangulum in runtime definition order' do
      allow(UpdateRuntimesForProjectJob).to receive(:perform_later)

      result = Triangulum::Validation::Result.new(valid?: true, return_type: nil, diagnostics: [])
      validation = instance_double(Triangulum::Validation, validate: result)
      allow(Triangulum::Validation).to receive(:new).and_return(validation)

      service.execute

      expect(Triangulum::Validation).to have_received(:new) do |grpc_flow, grpc_function_definitions, _data_types|
        expect(grpc_flow.node_functions.first.parameters.map(&:runtime_parameter_id)).to eq(%w[first second])
        expect(grpc_function_definitions.first.parameter_definitions.map(&:runtime_name)).to eq(%w[first second])
      end
    end
  end
end
