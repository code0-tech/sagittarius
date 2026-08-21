# frozen_string_literal: true

# Reads daily runtime usage aggregates for a single owner (flow/project/namespace, or the
# whole application) and buckets them into day/week/month periods. Callers are expected to
# have already validated the aggregation/date range (see
# Types::Concerns::HasRuntimeUsageField).
class RuntimeUsageDailyAggregatesFinder < ApplicationFinder
  def execute
    params[:relation]
      .where(date: params[:after_date]..params[:before_date])
      .group(Arel.sql("date_trunc('#{params[:aggregation]}', date)"))
      .order(Arel.sql("date_trunc('#{params[:aggregation]}', date)"))
      .pluck(
        Arel.sql("date_trunc('#{params[:aggregation]}', date)::date"),
        Arel.sql('SUM(execution_count)'),
        Arel.sql('SUM(total_execution_time_us)')
      )
      .map { |row| build_bucket(*row) }
  end

  private

  def build_bucket(period_start, execution_count, total_execution_time_us)
    RuntimeUsage::Bucket.new(
      period_start: period_start,
      period_end: period_end_for(period_start),
      usage: execution_count,
      value: total_execution_time_us / 1_000_000.0
    )
  end

  def period_end_for(period_start)
    case params[:aggregation]
    when 'day' then period_start
    when 'week' then period_start + 6.days
    when 'month' then period_start.end_of_month
    end
  end
end
