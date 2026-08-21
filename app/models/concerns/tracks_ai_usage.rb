# frozen_string_literal: true

# Atomically accumulates per-day AI generation counters via upsert, so concurrent
# generations landing on the same owner/day never lose a counter increment to a
# read-modify-write race. Mirrors TracksUsage's upsert shape for the AI usage metric
# returned by Velorum (a single usage number per generation call, rather than a
# count/duration pair).
module TracksAiUsage
  extend ActiveSupport::Concern

  class_methods do
    # unique_by: the conflict target's columns. Defaults to owner.keys + [:date], but callers
    # whose owner hash also carries denormalized, non-unique columns (e.g. project_id/
    # namespace_id alongside the real flow_id key) must pass it explicitly.
    def record_generation!(usage:, date: Time.zone.today, unique_by: nil, **owner)
      now = Time.current

      upsert_all( # rubocop:disable Rails/SkipsModelValidations -- atomic accumulate-on-conflict upsert is the point
        [owner.merge(date: date, generation_count: 1, total_usage: usage, created_at: now, updated_at: now)],
        unique_by: unique_by || (owner.keys + [:date]),
        on_duplicate: Arel.sql(<<~SQL.squish)
          generation_count = #{table_name}.generation_count + 1,
          total_usage = #{table_name}.total_usage + excluded.total_usage,
          updated_at = excluded.updated_at
        SQL
      )
    end
  end
end
