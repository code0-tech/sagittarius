# frozen_string_literal: true

module Usage
  # Reads daily usage aggregates for a single owner (flow/project/namespace, or the
  # whole application) and buckets them into day/week/month periods.
  #
  # The allowed after_date..before_date span is bounded per aggregation level, per the
  # product decision that days can be queried 7-31 days back, weeks 2-26 weeks back, and
  # months 2-24 months back.
  class FetchService
    ALLOWED_SPAN = {
      'day' => (7..31),
      'week' => (2..26),
      'month' => (2..24),
    }.freeze

    def initialize(relation:, aggregation:, after_date:, before_date:)
      @relation = relation
      @aggregation = aggregation
      @after_date = after_date
      @before_date = before_date
    end

    def execute
      validate_range!
      buckets
    end

    private

    attr_reader :relation, :aggregation, :after_date, :before_date

    def validate_range!
      raise GraphQL::ExecutionError, 'after_date must not be later than before_date' if after_date > before_date

      allowed_span = ALLOWED_SPAN.fetch(aggregation)
      return if allowed_span.cover?(span)

      raise GraphQL::ExecutionError,
            "Date range for #{aggregation} aggregation must span between " \
            "#{allowed_span.min} and #{allowed_span.max} #{aggregation}s, got #{span}"
    end

    def span
      case aggregation
      when 'day' then (before_date - after_date).to_i + 1
      when 'week' then weeks_between(after_date, before_date) + 1
      when 'month' then months_between(after_date, before_date) + 1
      end
    end

    # Counts distinct ISO weeks (Monday-start), matching date_trunc('week', ...) bucketing.
    def weeks_between(from, to)
      (to.beginning_of_week - from.beginning_of_week).to_i / 7
    end

    def months_between(from, to)
      ((to.year * 12) + to.month) - ((from.year * 12) + from.month)
    end

    def buckets
      relation
        .where(date: after_date..before_date)
        .group(Arel.sql("date_trunc('#{aggregation}', date)"))
        .order(Arel.sql("date_trunc('#{aggregation}', date)"))
        .pluck(
          Arel.sql("date_trunc('#{aggregation}', date)::date"),
          Arel.sql('SUM(execution_count)'),
          Arel.sql('SUM(total_execution_time_us)')
        )
        .map { |row| build_bucket(*row) }
    end

    def build_bucket(period_start, execution_count, total_execution_time_us)
      Bucket.new(
        period_start: period_start,
        period_end: period_end_for(period_start),
        execution_count: execution_count,
        total_execution_time: total_execution_time_us / 1_000_000.0
      )
    end

    def period_end_for(period_start)
      case aggregation
      when 'day' then period_start
      when 'week' then period_start + 6.days
      when 'month' then period_start.end_of_month
      end
    end
  end
end
