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
      allow(UpdateFlowForProjectJob).to receive(:perform_later)

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

      it 'enqueues UpdateFlowForProjectJob' do
        service.execute

        expect(UpdateFlowForProjectJob).to have_received(:perform_later).with(flow.id)
      end
    end

    context 'when validation fails' do
      let(:valid) { false }

      it 'sets validation status to invalid' do
        service.execute

        expect(flow.reload.validation_status).to eq('invalid')
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
  end
end
