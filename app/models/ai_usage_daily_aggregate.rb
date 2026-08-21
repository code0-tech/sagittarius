# frozen_string_literal: true

# One row per project per flow per day. namespace_id is denormalized from the project so
# namespace/application-level usage can be read by filtering (or not filtering, for
# application-wide) this single table instead of maintaining separate per-level tables.
class AiUsageDailyAggregate < ApplicationRecord
  include Code0::ZeroTrack::Database::Partitioning::PartitionedTable
  include TracksAiUsage

  # Prompt-based generation of a brand-new flow has no flow yet, and a partitioned table's
  # primary key columns can't contain NULL - rows without a real flow share this sentinel.
  NO_FLOW = 0

  partition_by :date, strategy: :monthly, retain_for: 25.months

  self.table_name = 'p_ai_usage_daily_aggregates'
  self.primary_key = %i[project_id flow_id date]

  # optional: true because there's no DB-level foreign key (see the migration) - the
  # flow/project/namespace may have been deleted while this usage row, tied to the license,
  # must persist.
  belongs_to :flow, inverse_of: :ai_usage_daily_aggregates, optional: true
  belongs_to :project, class_name: 'NamespaceProject', inverse_of: :ai_usage_daily_aggregates, optional: true
  belongs_to :namespace, inverse_of: :ai_usage_daily_aggregates, optional: true

  validates :date, presence: true, uniqueness: { scope: %i[project_id flow_id] }
end
