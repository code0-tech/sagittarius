# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::RecordExecutionUsageService do
  describe '#execute' do
    let(:flow) { create(:flow) }
    let(:execution_result) do
      create(:execution_result, flow: flow, started_at: 1_000, finished_at: 3_500, created_at: Time.zone.now)
    end

    it 'records a single denormalized usage row for the flow/project/namespace' do
      described_class.new(execution_result).execute

      date = execution_result.created_at.to_date
      project = flow.project

      expect(RuntimeUsageDailyAggregate.find_by(flow_id: flow.id, date: date)).to have_attributes(
        execution_count: 1,
        total_execution_time_us: 2_500,
        project_id: project.id,
        namespace_id: project.namespace_id
      )
      expect(RuntimeUsageDailyAggregate.count).to eq(1)
    end

    it 'returns a successful service response' do
      response = described_class.new(execution_result).execute

      expect(response).to be_success
    end
  end
end
