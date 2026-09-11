# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowHandler do
  describe '#flows_for' do
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

    context 'when an active license exists' do
      before { create(:license) }

      it 'returns the valid flows' do
        expect(described_class.new.flows_for(runtime).flows).to contain_exactly(flow.to_grpc)
      end
    end

    context 'when no active license exists' do
      it 'returns an empty flow list' do
        expect(described_class.new.flows_for(runtime).flows).to be_empty
      end
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

    context 'when no active license exists' do
      it 'does not push flow updates' do
        described_class.update_flow(flow)

        expect(gateway_client).not_to have_received(:push_flow)
      end

      it 'does not push flow deletions' do
        described_class.delete_flow(flow.project, flow.id)

        expect(gateway_client).not_to have_received(:push_flow)
      end
    end

    context 'when an active license exists' do
      before { create(:license) }

      it 'still pushes flow updates' do
        described_class.update_flow(flow)

        expect(gateway_client).to have_received(:push_flow)
      end
    end
  end

  describe '.update_runtime' do
    let(:flow) { create(:flow, validation_status: :valid) }
    let(:runtime) { create(:runtime, namespace: flow.project.namespace) }
    let(:gateway_client) { instance_double(Sagittarius::Gateway::Client, push_flow: nil, push_module_configuration: nil) }

    before do
      create(
        :namespace_project_runtime_assignment,
        namespace_project: flow.project,
        runtime: runtime,
        compatible: true
      )
      allow(described_class).to receive(:gateway_client).and_return(gateway_client)
    end

    context 'when no active license exists' do
      it 'only pushes an empty flow list and skips module configurations' do
        described_class.update_runtime(runtime)

        expect(gateway_client).to have_received(:push_flow).once do |runtime_id, response|
          expect(runtime_id).to eq(runtime.id)
          expect(response.flows.flows).to be_empty
        end
        expect(gateway_client).not_to have_received(:push_module_configuration)
      end
    end

    context 'when an active license exists' do
      before { create(:license) }

      it 'pushes the full flow and module configuration state' do
        described_class.update_runtime(runtime)

        expect(gateway_client).to have_received(:push_flow).at_least(:twice)
      end
    end
  end
end
