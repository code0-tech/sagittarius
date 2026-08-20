# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Usage::FetchService do
  let(:flow) { create(:flow) }
  let(:relation) { FlowUsageDailyAggregate.where(flow_id: flow.id) }

  def seed_day(date, execution_count:, total_execution_time_us:)
    FlowUsageDailyAggregate.insert!(
      {
        flow_id: flow.id,
        date: date,
        execution_count: execution_count,
        total_execution_time_us: total_execution_time_us,
        created_at: Time.current,
        updated_at: Time.current,
      }
    )
  end

  describe '#execute' do
    context 'with day aggregation' do
      it 'raises when the range is shorter than the allowed 7-31 day span' do
        service = described_class.new(
          relation: relation, aggregation: 'day', after_date: Date.new(2026, 8, 1), before_date: Date.new(2026, 8, 3)
        )

        expect { service.execute }.to raise_error(GraphQL::ExecutionError, /must span between 7 and 31/)
      end

      it 'returns one bucket per day in range' do
        seed_day(Date.new(2026, 8, 1), execution_count: 2, total_execution_time_us: 2_000_000)
        seed_day(Date.new(2026, 8, 2), execution_count: 3, total_execution_time_us: 3_000_000)

        service = described_class.new(
          relation: relation, aggregation: 'day', after_date: Date.new(2026, 8, 1), before_date: Date.new(2026, 8, 7)
        )

        buckets = service.execute

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
      it 'raises when after_date is later than before_date' do
        service = described_class.new(
          relation: relation, aggregation: 'month', after_date: Date.new(2026, 6, 1), before_date: Date.new(2026, 1, 1)
        )

        expect { service.execute }.to raise_error(GraphQL::ExecutionError, /after_date must not be later/)
      end

      it 'sums daily rows into a single monthly bucket' do
        seed_day(Date.new(2026, 6, 1), execution_count: 1, total_execution_time_us: 1_000_000)
        seed_day(Date.new(2026, 6, 15), execution_count: 4, total_execution_time_us: 4_000_000)

        service = described_class.new(
          relation: relation, aggregation: 'month', after_date: Date.new(2026, 5, 1), before_date: Date.new(2026, 6, 30)
        )

        buckets = service.execute

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
