# frozen_string_literal: true

class RuntimeModuleStatusDailyUptime < ApplicationRecord
  include Code0::ZeroTrack::Database::Partitioning::PartitionedTable

  partition_by :date, strategy: :daily, retain_for: 15.days

  self.table_name = 'p_runtime_module_status_daily_uptimes'
  self.primary_key = %i[id date]

  belongs_to :runtime_module_status, inverse_of: :daily_uptimes

  validates :date, presence: true, uniqueness: { scope: :runtime_module_status_id }
end
