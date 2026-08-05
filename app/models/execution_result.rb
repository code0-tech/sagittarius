# frozen_string_literal: true

class ExecutionResult < ApplicationRecord
  include Code0::ZeroTrack::Database::Partitioning::PartitionedTable
  include TruncateTimePrecision

  partition_by :created_at, strategy: :daily, retain_for: 1.month
  truncate_time_precision :created_at

  self.table_name = 'p_execution_results'
  self.primary_key = %i[id created_at]

  attr_readonly :execution_identifier

  belongs_to :flow, inverse_of: :execution_results

  has_many :node_results,
           class_name: 'ExecutionNodeResult',
           foreign_key: %i[execution_result_id created_at],
           inverse_of: :execution_result

  validates :execution_identifier, presence: true,
                                   allow_blank: false,
                                   uniqueness: { case_sensitive: false, scope: :flow_id }
  validates :started_at, :finished_at, numericality: { only_integer: true }
  validate :only_one_result_present

  private

  def only_one_result_present
    return if [!success.nil?, !error.nil?].count(true) <= 1

    errors.add(:base, 'Only one of success or error can be present')
  end
end
