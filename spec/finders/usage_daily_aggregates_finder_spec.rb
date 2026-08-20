# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsageDailyAggregatesFinder do
  let(:flow) { create(:flow) }
  let(:relation) { UsageDailyAggregate.where(flow_id: flow.id) }

  def seed_day(date, execution_count:, total_execution_time_us:)
    # rubocop:disable Rails/SkipsModelValidations -- seeding pre-aggregated rows directly, not exercising validations
    UsageDailyAggregate.insert!(
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
        seed_day(Date.new(2026, 8, 1), execution_count: 2, total_execution_time_us: 2_000_000)
        seed_day(Date.new(2026, 8, 2), execution_count: 3, total_execution_time_us: 3_000_000)

        finder = described_class.new(
          relation: relation, aggregation: 'day', after_date: Date.new(2026, 8, 1), before_date: Date.new(2026, 8, 7)
        )

        buckets = finder.execute

        expect(buckets.size).to eq(2)
        expect(buckets.first).to have_attributes(
          period_start: Date.new(2026, 8, 1),
          period_end: Date.new(2026, 8, 1),
          execution_count: 2,
          total_execution_time: 2.0
        )
      end
    end

    context 'with month aggregation' do
      it 'sums daily rows into a single monthly bucket' do
        seed_day(Date.new(2026, 6, 1), execution_count: 1, total_execution_time_us: 1_000_000)
        seed_day(Date.new(2026, 6, 15), execution_count: 4, total_execution_time_us: 4_000_000)

        finder = described_class.new(
          relation: relation, aggregation: 'month', after_date: Date.new(2026, 5, 1),
          before_date: Date.new(2026, 6, 30)
        )

        buckets = finder.execute

        expect(buckets.size).to eq(1)
        expect(buckets.first).to have_attributes(
          period_start: Date.new(2026, 6, 1),
          period_end: Date.new(2026, 6, 30),
          execution_count: 5,
          total_execution_time: 5.0
        )
      end
    end
  end
end
