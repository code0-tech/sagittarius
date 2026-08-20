# frozen_string_literal: true

# Atomically accumulates per-day execution counters via upsert, so concurrent
# executions landing on the same owner/day never lose a counter increment to a
# read-modify-write race.
module TracksUsage
  extend ActiveSupport::Concern

  class_methods do
    def record_execution!(execution_time_us:, date: Time.zone.today, **owner)
      now = Time.current

      upsert_all(
        [owner.merge(date: date, execution_count: 1, total_execution_time_us: execution_time_us,
                     created_at: now, updated_at: now)],
        unique_by: owner.keys + [:date],
        on_duplicate: Arel.sql(<<~SQL.squish)
          execution_count = #{table_name}.execution_count + 1,
          total_execution_time_us = #{table_name}.total_execution_time_us + excluded.total_execution_time_us,
          updated_at = excluded.updated_at
        SQL
      )
    end
  end
end
