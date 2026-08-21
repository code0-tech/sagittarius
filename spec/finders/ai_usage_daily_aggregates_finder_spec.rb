# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AiUsageDailyAggregatesFinder do
  let(:project) { create(:namespace_project) }
  let(:relation) { AiUsageDailyAggregate.where(project_id: project.id) }

  def seed_day(date, generation_count:, total_usage:)
    # rubocop:disable Rails/SkipsModelValidations -- seeding pre-aggregated rows directly, not exercising validations
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
    # rubocop:enable Rails/SkipsModelValidations
  end

  describe '#execute' do
    context 'with day aggregation' do
      it 'returns one bucket per day in range' do
        seed_day(Date.new(2026, 8, 1), generation_count: 2, total_usage: 200)
        seed_day(Date.new(2026, 8, 2), generation_count: 3, total_usage: 300)

        finder = described_class.new(
          relation: relation, aggregation: 'day', after_date: Date.new(2026, 8, 1), before_date: Date.new(2026, 8, 7)
        )

        buckets = finder.execute

        expect(buckets.size).to eq(2)
        expect(buckets.first).to have_attributes(
          period_start: Date.new(2026, 8, 1),
          period_end: Date.new(2026, 8, 1),
          usage: 2,
          value: 200
        )
      end
    end

    context 'with month aggregation' do
      it 'sums daily rows into a single monthly bucket' do
        seed_day(Date.new(2026, 6, 1), generation_count: 1, total_usage: 100)
        seed_day(Date.new(2026, 6, 15), generation_count: 4, total_usage: 400)

        finder = described_class.new(
          relation: relation, aggregation: 'month', after_date: Date.new(2026, 5, 1),
          before_date: Date.new(2026, 6, 30)
        )

        buckets = finder.execute

        expect(buckets.size).to eq(1)
        expect(buckets.first).to have_attributes(
          period_start: Date.new(2026, 6, 1),
          period_end: Date.new(2026, 6, 30),
          usage: 5,
          value: 500
        )
      end
    end
  end
end
