# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowUsageDailyAggregate do
  describe 'associations' do
    it { is_expected.to belong_to(:flow).inverse_of(:usage_daily_aggregates) }
  end

  describe 'validations' do
    subject { create(:flow_usage_daily_aggregate) }

    it { is_expected.to validate_uniqueness_of(:date).scoped_to(:flow_id) }
  end

  describe '.record_execution!' do
    let(:flow) { create(:flow) }
    let(:date) { Time.zone.today }

    it 'creates a row on first use' do
      described_class.record_execution!(flow_id: flow.id, date: date, execution_time_us: 1_500)

      aggregate = described_class.find_by(flow_id: flow.id, date: date)
      expect(aggregate.execution_count).to eq(1)
      expect(aggregate.total_execution_time_us).to eq(1_500)
    end

    it 'atomically accumulates on subsequent calls for the same owner/day' do
      described_class.record_execution!(flow_id: flow.id, date: date, execution_time_us: 1_000)
      described_class.record_execution!(flow_id: flow.id, date: date, execution_time_us: 2_000)

      aggregate = described_class.find_by(flow_id: flow.id, date: date)
      expect(aggregate.execution_count).to eq(2)
      expect(aggregate.total_execution_time_us).to eq(3_000)
    end

    it 'keeps separate rows for different days' do
      described_class.record_execution!(flow_id: flow.id, date: date, execution_time_us: 1_000)
      described_class.record_execution!(flow_id: flow.id, date: date - 1.day, execution_time_us: 500)

      expect(described_class.where(flow_id: flow.id).count).to eq(2)
    end
  end
end
