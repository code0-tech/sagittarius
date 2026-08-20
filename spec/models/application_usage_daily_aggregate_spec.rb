# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationUsageDailyAggregate do
  describe 'validations' do
    subject { create(:application_usage_daily_aggregate) }

    it { is_expected.to validate_uniqueness_of(:date) }
  end

  describe '.record_execution!' do
    it 'accumulates the instance-wide counters with no owner scope' do
      date = Time.zone.today

      described_class.record_execution!(date: date, execution_time_us: 1_000)
      described_class.record_execution!(date: date, execution_time_us: 2_000)

      aggregate = described_class.find_by(date: date)
      expect(aggregate.execution_count).to eq(2)
      expect(aggregate.total_execution_time_us).to eq(3_000)
    end
  end
end
