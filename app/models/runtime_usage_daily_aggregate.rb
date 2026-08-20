# frozen_string_literal: true

# One row per flow per day. project_id/namespace_id are denormalized from the flow so
# project/namespace/application-level usage can be read by filtering (or not filtering,
# for application-wide) this single table instead of maintaining separate per-level tables.
class RuntimeUsageDailyAggregate < ApplicationRecord
  include Code0::ZeroTrack::Database::Partitioning::PartitionedTable
  include TracksUsage

  partition_by :date, strategy: :monthly, retain_for: 25.months

  self.table_name = 'p_runtime_usage_daily_aggregates'
  self.primary_key = %i[flow_id date]

  # optional: true because there's no DB-level foreign key (see the migration) - the
  # flow/project/namespace may have been deleted while this usage row, tied to the license,
  # must persist.
  belongs_to :flow, inverse_of: :runtime_usage_daily_aggregates, optional: true
  belongs_to :project, class_name: 'NamespaceProject', inverse_of: :runtime_usage_daily_aggregates, optional: true
  belongs_to :namespace, inverse_of: :runtime_usage_daily_aggregates, optional: true

  validates :date, presence: true, uniqueness: { scope: :flow_id }
end
