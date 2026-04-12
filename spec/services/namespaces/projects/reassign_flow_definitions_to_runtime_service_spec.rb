# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::ReassignFlowDefinitionsToRuntimeService do
  subject(:execute) { described_class.new(project, runtime).execute }

  let(:runtime) { create(:runtime) }
  let(:project) { create(:namespace_project, primary_runtime: runtime) }

  let!(:first_flow) { create(:flow, project: project, flow_type: create(:flow_type, runtime: runtime)) }
  let!(:second_flow) { create(:flow, project: project, flow_type: create(:flow_type, runtime: runtime)) }
  let(:other_project) { create(:namespace_project) }
  let!(:other_flow) { create(:flow, project: other_project) }

  it 'calls ReassignDefinitionsToRuntimeService for each flow' do
    service = instance_double(Namespaces::Projects::Flows::ReassignDefinitionsToRuntimeService)
    allow(Namespaces::Projects::Flows::ReassignDefinitionsToRuntimeService).to receive(:new).and_return(service)
    allow(service).to receive(:execute)

    execute

    expect(Namespaces::Projects::Flows::ReassignDefinitionsToRuntimeService)
      .to have_received(:new).with(first_flow, runtime)
    expect(Namespaces::Projects::Flows::ReassignDefinitionsToRuntimeService)
      .to have_received(:new).with(second_flow, runtime)
    expect(Namespaces::Projects::Flows::ReassignDefinitionsToRuntimeService)
      .not_to have_received(:new).with(other_flow, anything)
  end
end
