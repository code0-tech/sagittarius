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

    context 'when a duration weight threshold is configured' do
      before do
        stub_application_settings(runtime_usage_duration_weight_threshold_seconds: 5)
      end

      def execution_count_for(flow)
        RuntimeUsageDailyAggregate.find_by(flow_id: flow.id, date: Time.zone.today).execution_count
      end

      it 'counts an execution at or below the threshold as 1' do
        described_class.new(flow: flow, duration: 5_000_000).execute

        expect(execution_count_for(flow)).to eq(1)
      end

      it 'counts an execution just above the threshold as 2' do
        described_class.new(flow: flow, duration: 6_000_000).execute

        expect(execution_count_for(flow)).to eq(2)
      end

      it 'adds one per whole threshold interval' do
        described_class.new(flow: flow, duration: 11_000_000).execute

        expect(execution_count_for(flow)).to eq(3)
      end
    end

    it 'counts every execution as 1 when weighting is disabled (threshold 0)' do
      stub_application_settings(runtime_usage_duration_weight_threshold_seconds: 0)

      described_class.new(flow: flow, duration: 60_000_000).execute

      expect(RuntimeUsageDailyAggregate.find_by(flow_id: flow.id, date: Time.zone.today).execution_count).to eq(1)
    end

    it 'returns an error response if recording usage fails' do
      allow(RuntimeUsageDailyAggregate).to receive(:record_execution!).and_raise(StandardError, 'boom')

      response = described_class.new(flow: flow, duration: 2_500).execute

      expect(response).to be_error
      expect(response.payload[:error_code]).to eq(:execution_usage_recording_failed)
    end
  end
end
