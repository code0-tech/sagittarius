# frozen_string_literal: true

# Instance-wide (not per-namespace/project/flow) execution usage, rolled up per day.
# Exposed only to instance/cloud admins.
class ApplicationUsageDailyAggregate < ApplicationRecord
  include Code0::ZeroTrack::Database::Partitioning::PartitionedTable
  include TracksUsage

  partition_by :date, strategy: :monthly, retain_for: 25.months

  self.table_name = 'p_application_usage_daily_aggregates'
  self.primary_key = :date

  validates :date, presence: true, uniqueness: true
end
