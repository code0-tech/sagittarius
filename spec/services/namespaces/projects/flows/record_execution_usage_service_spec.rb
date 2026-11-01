# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::RecordExecutionUsageService do
  describe '#execute' do
    let(:flow) { create(:flow) }

    it 'records a single denormalized usage row for the flow/project/namespace' do
      described_class.new(flow: flow, duration: 2_500).execute

      project = flow.project

      expect(RuntimeUsageDailyAggregate.find_by(flow_id: flow.id, date: Time.zone.today)).to have_attributes(
        execution_count: 1,
        total_execution_time_us: 2_500,
        project_id: project.id,
        namespace_id: project.namespace_id
      )
      expect(RuntimeUsageDailyAggregate.count).to eq(1)
    end

    it 'returns a successful service response' do
      response = described_class.new(flow: flow, duration: 2_500).execute

      expect(response).to be_success
    end

    context 'when weighting an execution by its duration (30s threshold)' do
      def execution_count_for(flow)
        RuntimeUsageDailyAggregate.find_by(flow_id: flow.id, date: Time.zone.today).execution_count
      end

      it 'rounds a just-over-threshold execution back down to 1' do
        described_class.new(flow: flow, duration: 31_000_000).execute

        expect(execution_count_for(flow)).to eq(1)
      end

      it 'rounds up to 2 once past the halfway point' do
        described_class.new(flow: flow, duration: 46_000_000).execute

        expect(execution_count_for(flow)).to eq(2)
      end

      it 'rounds to the nearest whole interval for longer executions' do
        described_class.new(flow: flow, duration: 75_000_000).execute

        expect(execution_count_for(flow)).to eq(3)
      end
    end

    it 'returns an error response if recording usage fails' do
      allow(RuntimeUsageDailyAggregate).to receive(:record_execution!).and_raise(StandardError, 'boom')

      response = described_class.new(flow: flow, duration: 2_500).execute

      expect(response).to be_error
      expect(response.payload[:error_code]).to eq(:execution_usage_recording_failed)
    end
  end
end
