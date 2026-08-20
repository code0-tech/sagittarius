# frozen_string_literal: true

class FlowUsageDailyAggregate < ApplicationRecord
  include Code0::ZeroTrack::Database::Partitioning::PartitionedTable
  include TracksUsage

  partition_by :date, strategy: :monthly, retain_for: 25.months

  self.table_name = 'p_flow_usage_daily_aggregates'
  self.primary_key = %i[flow_id date]

  belongs_to :flow, inverse_of: :usage_daily_aggregates

  validates :date, presence: true, uniqueness: { scope: :flow_id }
end
