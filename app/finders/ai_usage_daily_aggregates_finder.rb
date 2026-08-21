# frozen_string_literal: true

# Reads daily AI generation usage aggregates for a single owner (flow/project/namespace, or
# the whole application) and buckets them into day/week/month periods. Callers are expected
# to have already validated the aggregation/date range (see
# Types::Concerns::HasAiUsageField).
class AiUsageDailyAggregatesFinder < ApplicationFinder
  def execute
    params[:relation]
      .where(date: params[:after_date]..params[:before_date])
      .group(Arel.sql("date_trunc('#{params[:aggregation]}', date)"))
      .order(Arel.sql("date_trunc('#{params[:aggregation]}', date)"))
      .pluck(
        Arel.sql("date_trunc('#{params[:aggregation]}', date)::date"),
        Arel.sql('SUM(generation_count)'),
        Arel.sql('SUM(total_usage)')
      )
      .map { |row| build_bucket(*row) }
  end

  private

  def build_bucket(period_start, generation_count, total_usage)
    Usage::Bucket.new(
      period_start: period_start,
      period_end: period_end_for(period_start),
      usage: generation_count,
      value: total_usage
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
