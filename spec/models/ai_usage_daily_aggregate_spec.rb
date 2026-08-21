# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AiUsageDailyAggregate do
  describe 'associations' do
    it { is_expected.to belong_to(:flow).inverse_of(:ai_usage_daily_aggregates).optional }

    it {
      is_expected.to belong_to(:project).class_name('NamespaceProject')
                                        .inverse_of(:ai_usage_daily_aggregates).optional
    }

    it { is_expected.to belong_to(:namespace).inverse_of(:ai_usage_daily_aggregates).optional }
  end

  describe 'validations' do
    subject { create(:ai_usage_daily_aggregate) }

    it { is_expected.to validate_uniqueness_of(:date).scoped_to(%i[project_id flow_id]) }
  end

  describe '.record_generation!' do
    let(:project) { create(:namespace_project) }
    let(:date) { Time.zone.today }

    def record(usage:, flow_id: described_class::NO_FLOW, record_date: date)
      described_class.record_generation!(
        project_id: project.id, namespace_id: project.namespace_id, flow_id: flow_id,
        date: record_date, usage: usage, unique_by: %i[project_id flow_id date]
      )
    end

    it 'creates a row on first use, denormalizing namespace_id' do
      record(usage: 150)

      aggregate = described_class.find_by(project_id: project.id, flow_id: described_class::NO_FLOW, date: date)
      expect(aggregate.generation_count).to eq(1)
      expect(aggregate.total_usage).to eq(150)
      expect(aggregate.namespace_id).to eq(project.namespace_id)
    end

    it 'atomically accumulates on subsequent calls for the same project/flow/day' do
      record(usage: 100)
      record(usage: 200)

      aggregate = described_class.find_by(project_id: project.id, flow_id: described_class::NO_FLOW, date: date)
      expect(aggregate.generation_count).to eq(2)
      expect(aggregate.total_usage).to eq(300)
    end

    it 'keeps separate rows for different flows in the same project/day' do
      flow = create(:flow, project: project)

      record(usage: 100)
      record(usage: 200, flow_id: flow.id)

      expect(described_class.where(project_id: project.id).count).to eq(2)
    end

    it 'keeps separate rows for different days' do
      record(usage: 100)
      record(usage: 50, record_date: date - 1.day)

      expect(described_class.where(project_id: project.id).count).to eq(2)
    end
  end
end
