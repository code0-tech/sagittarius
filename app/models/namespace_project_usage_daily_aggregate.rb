# frozen_string_literal: true

class NamespaceProjectUsageDailyAggregate < ApplicationRecord
  include Code0::ZeroTrack::Database::Partitioning::PartitionedTable
  include TracksUsage

  partition_by :date, strategy: :monthly, retain_for: 25.months

  self.table_name = 'p_namespace_project_usage_daily_aggregates'
  self.primary_key = %i[project_id date]

  belongs_to :project, class_name: 'NamespaceProject', inverse_of: :usage_daily_aggregates

  validates :date, presence: true, uniqueness: { scope: :project_id }
end
