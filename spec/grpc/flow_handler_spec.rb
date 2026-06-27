# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowHandler do
  let(:flow) { create(:flow, validation_status: :valid) }
  let(:runtime) { create(:runtime, namespace: flow.project.namespace) }

  before do
    create(
      :namespace_project_runtime_assignment,
      namespace_project: flow.project,
      runtime: runtime,
      compatible: true
    )
    allow(described_class).to receive(:send_update)
  end

  describe '.update_flow' do
    it 'sends the updated_flow response to compatible project runtimes' do
      described_class.update_flow(flow)

      expect(described_class).to have_received(:send_update) do |response, runtime_id|
        expect(runtime_id).to eq(runtime.id)
        expect(response.data).to eq(:updated_flow)
        expect(response.updated_flow).to eq(flow.to_grpc)
      end
    end
  end

  describe '.delete_flow' do
    it 'sends the deleted_flow_id response to compatible project runtimes' do
      described_class.delete_flow(flow.project, flow.id)

      expect(described_class).to have_received(:send_update) do |response, runtime_id|
        expect(runtime_id).to eq(runtime.id)
        expect(response.data).to eq(:deleted_flow_id)
        expect(response.deleted_flow_id).to eq(flow.id)
      end
    end
  end
end
