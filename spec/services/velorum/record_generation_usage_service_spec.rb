# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Velorum::RecordGenerationUsageService do
  describe '#execute' do
    let(:project) { create(:namespace_project) }

    context 'when no flow is given' do
      it 'records a denormalized usage row keyed by the no-flow sentinel' do
        described_class.new(project: project, usage: 42).execute

        aggregate = AiUsageDailyAggregate.find_by(project_id: project.id, flow_id: AiUsageDailyAggregate::NO_FLOW)
        expect(aggregate).to have_attributes(
          generation_count: 1,
          total_usage: 42,
          namespace_id: project.namespace_id
        )
        expect(AiUsageDailyAggregate.count).to eq(1)
      end
    end

    context 'when a flow is given' do
      let(:flow) { create(:flow, project: project) }

      it 'records a denormalized usage row for the flow/project/namespace' do
        described_class.new(project: project, usage: 17, flow: flow).execute

        aggregate = AiUsageDailyAggregate.find_by(project_id: project.id, flow_id: flow.id)
        expect(aggregate).to have_attributes(
          generation_count: 1,
          total_usage: 17,
          namespace_id: project.namespace_id
        )
      end
    end

    it 'returns a successful service response' do
      response = described_class.new(project: project, usage: 5).execute

      expect(response).to be_success
    end
  end
end
