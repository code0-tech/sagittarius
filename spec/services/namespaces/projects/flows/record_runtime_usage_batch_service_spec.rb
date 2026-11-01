# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::RecordRuntimeUsageBatchService do
  describe '#execute' do
    let(:runtime) { create(:runtime) }
    let(:project) { create(:namespace_project, primary_runtime: runtime) }
    let(:flow) { create(:flow, project: project) }
    let(:other_flow) { create(:flow, project: project) }

    before do
      create(:namespace_project_runtime_assignment, runtime: runtime, namespace_project: project)
    end

    def usage(flow_id, duration)
      Tucana::Shared::RuntimeUsage.new(flow_id: flow_id, duration: duration)
    end

    it 'records each resolvable entry and returns a successful response' do
      response = described_class.new([usage(flow.id, 1_000), usage(other_flow.id, 2_000)], runtime.id).execute

      expect(response).to be_success
      expect(RuntimeUsageDailyAggregate.find_by(flow_id: flow.id).total_execution_time_us).to eq(1_000)
      expect(RuntimeUsageDailyAggregate.find_by(flow_id: other_flow.id).total_execution_time_us).to eq(2_000)
    end

    it 'skips entries whose flow_id does not resolve for the reporting runtime' do
      response = described_class.new([usage(flow.id + 1_000_000, 1_000)], runtime.id).execute

      expect(response).to be_success
      expect(RuntimeUsageDailyAggregate.count).to eq(0)
    end

    it 'enforces the usage limit once per unique flow touched, not once per entry' do
      service = instance_double(Namespaces::Projects::Flows::EnforceUsageLimitService, execute: nil)
      allow(Namespaces::Projects::Flows::EnforceUsageLimitService).to receive(:new).and_return(service)

      described_class.new([usage(flow.id, 1_000), usage(flow.id, 500)], runtime.id).execute

      expect(Namespaces::Projects::Flows::EnforceUsageLimitService).to have_received(:new).with(flow).once
      expect(service).to have_received(:execute).once
    end

    it 'does not enforce for a flow whose entry was skipped' do
      allow(Namespaces::Projects::Flows::EnforceUsageLimitService).to receive(:new)

      described_class.new([usage(flow.id + 1_000_000, 1_000)], runtime.id).execute

      expect(Namespaces::Projects::Flows::EnforceUsageLimitService).not_to have_received(:new)
    end
  end
end
