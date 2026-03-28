# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::ValidationService do
  subject(:service) { described_class.new(flow) }

  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project) }
  let(:flow_type) { create(:flow_type, runtime: runtime) }
  let(:runtime_function_definition) { create(:runtime_function_definition, runtime: runtime) }
  let(:function_definition) { create(:function_definition, runtime_function_definition: runtime_function_definition) }
  let(:node_function) { create(:node_function, flow: flow, function_definition: function_definition) }
  let(:flow) do
    create(:flow, project: namespace_project, flow_type: flow_type, validation_status: :unvalidated,
                  starting_node: nil)
  end

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
