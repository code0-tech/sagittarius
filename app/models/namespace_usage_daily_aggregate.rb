# frozen_string_literal: true

class NamespaceUsageDailyAggregate < ApplicationRecord
  include Code0::ZeroTrack::Database::Partitioning::PartitionedTable
  include TracksUsage

  partition_by :date, strategy: :monthly, retain_for: 25.months

  self.table_name = 'p_namespace_usage_daily_aggregates'
  self.primary_key = %i[namespace_id date]

  belongs_to :namespace, inverse_of: :usage_daily_aggregates

  validates :date, presence: true, uniqueness: { scope: :namespace_id }
end
