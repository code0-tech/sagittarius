# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowHandler do
  describe '.grouped_module_configurations' do
    let(:runtime) { create(:runtime) }
    let(:project) { create(:namespace_project) }
    let(:assignment) do
      create(:namespace_project_runtime_assignment,
             namespace_project: project,
             runtime: runtime,
             compatible: true)
    end
    let(:runtime_module) { create(:runtime_module, runtime: runtime, identifier: 'example-action') }
    let!(:saved_definition) do
      create(:module_configuration_definition,
             runtime_module: runtime_module,
             identifier: 'EXAMPLE_CONFIG',
             default_value: 'default')
    end
    let(:default_definition) do
      create(:module_configuration_definition,
             runtime_module: runtime_module,
             identifier: 'SECOND_CONFIG',
             default_value: 'second-default')
    end

    before do
      create(:module_configuration,
             namespace_project_runtime_assignment: assignment,
             module_configuration_definition: saved_definition,
             value: 'saved')
    end

    it 'uses saved values and falls back to definition defaults for missing project values' do
      default_definition

      module_configurations = described_class.grouped_module_configurations([assignment], [runtime_module])

      expect(module_configurations.length).to eq(1)
      expect(module_configurations.first.module_identifier).to eq('example-action')

      project_configurations = module_configurations.first.module_configurations.sole
      expect(project_configurations.project_id).to eq(project.id)
      expect(
        project_configurations.module_configurations.map do |configuration|
          [configuration.identifier, configuration.value.to_ruby(true)]
        end
      ).to eq(
        [
          %w[EXAMPLE_CONFIG saved],
          %w[SECOND_CONFIG second-default]
        ]
      )
    end
  end

  describe 'project runtime updates' do
    let(:flow) { create(:flow, validation_status: :valid) }
    let(:runtime) { create(:runtime, namespace: flow.project.namespace) }
    let(:gateway_client) { instance_double(Sagittarius::Gateway::Client, push_flow: nil) }

    before do
      create(
        :namespace_project_runtime_assignment,
        namespace_project: flow.project,
        runtime: runtime,
        compatible: true
      )
      allow(described_class).to receive(:gateway_client).and_return(gateway_client)
    end

    describe '.update_flow' do
      it 'pushes the updated_flow response to compatible project runtimes' do
        described_class.update_flow(flow)

        expect(gateway_client).to have_received(:push_flow) do |runtime_id, response|
          expect(runtime_id).to eq(runtime.id)
          expect(response).to be_a(Tucana::Sagittarius::Gateway::FlowResponse)
          expect(response.data).to eq(:updated_flow)
          expect(response.updated_flow).to eq(flow.to_grpc)
        end
      end
    end

    describe '.delete_flow' do
      it 'pushes the deleted_flow_id response to compatible project runtimes' do
        described_class.delete_flow(flow.project, flow.id)

        expect(gateway_client).to have_received(:push_flow) do |runtime_id, response|
          expect(runtime_id).to eq(runtime.id)
          expect(response.data).to eq(:deleted_flow_id)
          expect(response.deleted_flow_id).to eq(flow.id)
        end
      end
    end
  end

  describe '#update' do
    let(:flow) { create(:flow, validation_status: :valid) }
    let(:runtime) { create(:runtime, namespace: flow.project.namespace) }

    before do
      create(
        :namespace_project_runtime_assignment,
        namespace_project: flow.project,
        runtime: runtime,
        compatible: true
      )
    end

    it "returns the current runtime's full valid-flow state" do
      response = Code0::ZeroTrack::Context.with_context(runtime: { id: runtime.id, namespace_id: nil }) do
        described_class.new.update(Tucana::Sagittarius::Rails::FlowLogonRequest.new, nil)
      end

      expect(response.data).to eq(:flows)
      expect(response.flows.flows).to contain_exactly(flow.to_grpc)
    end
  end
end
