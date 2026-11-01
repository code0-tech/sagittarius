# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeUsageHandler do
  describe '#update' do
    let(:runtime) { create(:runtime) }
    let(:project) { create(:namespace_project, primary_runtime: runtime) }
    let(:flow) { create(:flow, project: project) }

    before do
      create(:namespace_project_runtime_assignment, runtime: runtime, namespace_project: project)
    end

    def call(request)
      Code0::ZeroTrack::Context.with_context(runtime: { id: runtime.id, namespace_id: nil }) do
        described_class.new.update(request, nil)
      end
    end

    it 'records usage for the reported flow and returns a successful response' do
      request = Tucana::Sagittarius::Rails::RuntimeUsageRequest.new(
        runtime_usage: [Tucana::Shared::RuntimeUsage.new(flow_id: flow.id, duration: 2_500)]
      )

      response = call(request)

      expect(response).to be_a(Tucana::Sagittarius::Rails::RuntimeUsageResponse)
      expect(response.success).to be(true)
      expect(RuntimeUsageDailyAggregate.find_by(flow_id: flow.id)).to have_attributes(
        execution_count: 1,
        total_execution_time_us: 2_500
      )
    end

    it 'accumulates multiple entries for the same flow in one batch' do
      request = Tucana::Sagittarius::Rails::RuntimeUsageRequest.new(
        runtime_usage: [
          Tucana::Shared::RuntimeUsage.new(flow_id: flow.id, duration: 1_000),
          Tucana::Shared::RuntimeUsage.new(flow_id: flow.id, duration: 1_500)
        ]
      )

      response = call(request)

      expect(response.success).to be(true)
      expect(RuntimeUsageDailyAggregate.find_by(flow_id: flow.id)).to have_attributes(
        execution_count: 2,
        total_execution_time_us: 2_500
      )
    end

    it 'skips an unknown flow_id without failing the response' do
      request = Tucana::Sagittarius::Rails::RuntimeUsageRequest.new(
        runtime_usage: [Tucana::Shared::RuntimeUsage.new(flow_id: flow.id + 1_000_000, duration: 1_000)]
      )

      response = call(request)

      expect(response.success).to be(true)
      expect(RuntimeUsageDailyAggregate.count).to eq(0)
    end

    it 'does not record usage for a flow belonging to a different runtime' do
      other_runtime = create(:runtime)
      other_project = create(:namespace_project, primary_runtime: other_runtime)
      other_flow = create(:flow, project: other_project)
      create(:namespace_project_runtime_assignment, runtime: other_runtime, namespace_project: other_project)

      request = Tucana::Sagittarius::Rails::RuntimeUsageRequest.new(
        runtime_usage: [Tucana::Shared::RuntimeUsage.new(flow_id: other_flow.id, duration: 1_000)]
      )

      response = call(request)

      expect(response.success).to be(true)
      expect(RuntimeUsageDailyAggregate.where(flow_id: other_flow.id)).to be_empty
    end
  end
end
