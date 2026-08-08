# frozen_string_literal: true

class ExecutionParameterResult < ApplicationRecord
  include Code0::ZeroTrack::Database::Partitioning::PartitionedTable
  include TruncateTimePrecision

  partition_by :created_at, strategy: :daily, retain_for: 1.month
  truncate_time_precision :created_at

  self.table_name = 'p_execution_parameter_results'
  self.primary_key = %i[id created_at]

  belongs_to :execution_node_result,
             foreign_key: %i[execution_node_result_id created_at],
             inverse_of: :parameter_results

  validates :position, presence: true, numericality: { only_integer: true }
end
