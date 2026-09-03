# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AiUsageDailyAggregatesFinder do
  let(:project) { create(:namespace_project) }
  let(:relation) { AiUsageDailyAggregate.where(project_id: project.id) }

  def seed_day(date, generation_count:, total_usage:)
    # rubocop:disable-next Rails/SkipsModelValidations -- seeding pre-aggregated rows directly, not exercising validations
    AiUsageDailyAggregate.insert!(
      {
        project_id: project.id,
        flow_id: AiUsageDailyAggregate::NO_FLOW,
        namespace_id: project.namespace_id,
        date: date,
        generation_count: generation_count,
        total_usage: total_usage,
        created_at: Time.current,
        updated_at: Time.current,
      }
    )
  end

  describe '#execute' do
    context 'with day aggregation' do
      it 'returns one bucket per day in range' do
        today = Time.zone.today
        seed_day(today, generation_count: 2, total_usage: 200)
        seed_day(today + 1.day, generation_count: 3, total_usage: 300)

        finder = described_class.new(
          relation: relation, aggregation: 'day', after_date: today, before_date: today + 6.days
        )

        buckets = finder.execute

        expect(buckets.size).to eq(2)
        expect(buckets.first).to have_attributes(
          period_start: today,
          period_end: today,
          usage: 2,
          value: 200
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
        seed_day(month_start, generation_count: 1, total_usage: 100)
        seed_day(month_start + 14.days, generation_count: 4, total_usage: 400)

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
          value: 500
        )
      end
    end
  end
end
