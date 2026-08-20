# frozen_string_literal: true

# Atomically accumulates per-day execution counters via upsert, so concurrent
# executions landing on the same owner/day never lose a counter increment to a
# read-modify-write race.
module TracksUsage
  extend ActiveSupport::Concern

  class_methods do
    # unique_by: the conflict target's columns. Defaults to owner.keys + [:date], but callers
    # whose owner hash also carries denormalized, non-unique columns (e.g. project_id/
    # namespace_id alongside the real flow_id key) must pass it explicitly.
    def record_execution!(execution_time_us:, date: Time.zone.today, unique_by: nil, **owner)
      now = Time.current

      upsert_all( # rubocop:disable Rails/SkipsModelValidations -- atomic accumulate-on-conflict upsert is the point
        [owner.merge(date: date, execution_count: 1, total_execution_time_us: execution_time_us,
                     created_at: now, updated_at: now)],
        unique_by: unique_by || (owner.keys + [:date]),
        on_duplicate: Arel.sql(<<~SQL.squish)
          execution_count = #{table_name}.execution_count + 1,
          total_execution_time_us = #{table_name}.total_execution_time_us + excluded.total_execution_time_us,
          updated_at = excluded.updated_at
        SQL
      )
    end
  end
end
