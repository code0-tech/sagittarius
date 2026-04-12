# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::ReassignDefinitionsToRuntimeService do
  subject(:execute) { described_class.new(flow, new_runtime).execute }

  let!(:old_runtime) { create(:runtime) }
  let!(:new_runtime) { create(:runtime) }

  let!(:flow_type_identifier) { 'shared_flow_type' }
  let!(:old_flow_type) { create(:flow_type, runtime: old_runtime, identifier: flow_type_identifier) }
  let!(:new_flow_type) { create(:flow_type, runtime: new_runtime, identifier: flow_type_identifier) }

  let!(:runtime_name) { 'shared_function' }
  let!(:old_rfd) { create(:runtime_function_definition, runtime: old_runtime, runtime_name: runtime_name) }
  let!(:new_rfd) { create(:runtime_function_definition, runtime: new_runtime, runtime_name: runtime_name) }

  let!(:old_fd) { create(:function_definition, runtime_function_definition: old_rfd) }
  let!(:new_fd) { create(:function_definition, runtime_function_definition: new_rfd) }

  let!(:rpd_runtime_name) { 'shared_param' }
  let!(:old_rpd) do
    create(:runtime_parameter_definition, runtime_function_definition: old_rfd, runtime_name: rpd_runtime_name)
  end
  let!(:new_rpd) do
    create(:runtime_parameter_definition, runtime_function_definition: new_rfd, runtime_name: rpd_runtime_name)
  end

  let!(:old_pd) { create(:parameter_definition, runtime_parameter_definition: old_rpd, function_definition: old_fd) }
  let!(:new_pd) { create(:parameter_definition, runtime_parameter_definition: new_rpd, function_definition: new_fd) }

  let(:namespace_project) { create(:namespace_project, primary_runtime: old_runtime) }
  let(:flow) { create(:flow, project: namespace_project, flow_type: old_flow_type) }

  let!(:node) { create(:node_function, flow: flow, function_definition: old_fd) }
  let!(:node_parameter) { create(:node_parameter, node_function: node, parameter_definition: old_pd) }

  describe '#execute' do
    it 'reassigns the flow type to the new runtime' do
      execute

      expect(flow.reload.flow_type).to eq(new_flow_type)
    end

    it 'reassigns node function definitions to the new runtime' do
      execute

      expect(node.reload.function_definition).to eq(new_fd)
    end

    it 'reassigns node parameter definitions to the new runtime' do
      execute

      expect(node_parameter.reload.parameter_definition).to eq(new_pd)
    end
  end
end
