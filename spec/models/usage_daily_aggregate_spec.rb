# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsageDailyAggregate do
  describe 'associations' do
    it { is_expected.to belong_to(:flow).inverse_of(:usage_daily_aggregates) }
    it { is_expected.to belong_to(:project).class_name('NamespaceProject').inverse_of(:usage_daily_aggregates) }
    it { is_expected.to belong_to(:namespace).inverse_of(:usage_daily_aggregates) }
  end

  describe 'validations' do
    subject { create(:usage_daily_aggregate) }

    it { is_expected.to validate_uniqueness_of(:date).scoped_to(:flow_id) }
  end

  describe '.record_execution!' do
    let(:flow) { create(:flow) }
    let(:project) { flow.project }
    let(:date) { Time.zone.today }

    def record(execution_time_us:, record_date: date)
      described_class.record_execution!(
        flow_id: flow.id, project_id: project.id, namespace_id: project.namespace_id,
        date: record_date, execution_time_us: execution_time_us, unique_by: %i[flow_id date]
      )
    end

    it 'creates a row on first use, denormalizing project_id/namespace_id' do
      record(execution_time_us: 1_500)

      aggregate = described_class.find_by(flow_id: flow.id, date: date)
      expect(aggregate.execution_count).to eq(1)
      expect(aggregate.total_execution_time_us).to eq(1_500)
      expect(aggregate.project_id).to eq(project.id)
      expect(aggregate.namespace_id).to eq(project.namespace_id)
    end

    it 'atomically accumulates on subsequent calls for the same flow/day' do
      record(execution_time_us: 1_000)
      record(execution_time_us: 2_000)

      aggregate = described_class.find_by(flow_id: flow.id, date: date)
      expect(aggregate.execution_count).to eq(2)
      expect(aggregate.total_execution_time_us).to eq(3_000)
    end

    it 'keeps separate rows for different days' do
      record(execution_time_us: 1_000)
      record(execution_time_us: 500, record_date: date - 1.day)

      expect(described_class.where(flow_id: flow.id).count).to eq(2)
    end
  end
end
