# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeUsageDailyAggregatesFinder do
  let(:flow) { create(:flow) }
  let(:relation) { RuntimeUsageDailyAggregate.where(flow_id: flow.id) }

  def seed_day(date, execution_count:, total_execution_time_us:)
    # rubocop:disable Rails/SkipsModelValidations -- seeding pre-aggregated rows directly, not exercising validations
    RuntimeUsageDailyAggregate.insert!(
      {
        flow_id: flow.id,
        project_id: flow.project_id,
        namespace_id: flow.project.namespace_id,
        date: date,
        execution_count: execution_count,
        total_execution_time_us: total_execution_time_us,
        created_at: Time.current,
        updated_at: Time.current,
      }
    )
    # rubocop:enable Rails/SkipsModelValidations
  end

  describe '#execute' do
    context 'with day aggregation' do
      it 'returns one bucket per day in range' do
        today = Time.zone.today
        seed_day(today, execution_count: 2, total_execution_time_us: 2_000_000)
        seed_day(today + 1.day, execution_count: 3, total_execution_time_us: 3_000_000)

        finder = described_class.new(
          relation: relation, aggregation: 'day', after_date: today, before_date: today + 6.days
        )

        buckets = finder.execute

        expect(buckets.size).to eq(2)
        expect(buckets.first).to have_attributes(
          period_start: today,
          period_end: today,
          usage: 2,
          value: 2.0
        )
      end
    end

    context 'with month aggregation' do
      it 'sums daily rows into a single monthly bucket' do
        # Partitions only exist within the strategy's retention/headroom window (see
        # Code0::ZeroTrack::Database::Partitioning::Strategy::Time), so dates must stay
        # relative to today rather than hardcoded, or this test would eventually fail once
        # the fixed dates fall outside the currently materialized partitions.
        month_start = 1.month.ago.to_date.beginning_of_month
        seed_day(month_start, execution_count: 1, total_execution_time_us: 1_000_000)
        seed_day(month_start + 14.days, execution_count: 4, total_execution_time_us: 4_000_000)

        finder = described_class.new(
          relation: relation, aggregation: 'month', after_date: month_start - 1.month,
          before_date: month_start.end_of_month
        )

        buckets = finder.execute

        expect(buckets.size).to eq(1)
        expect(buckets.first).to have_attributes(
          period_start: month_start,
          period_end: month_start.end_of_month,
          usage: 5,
          value: 5.0
        )
      end
    end
  end
end
