# frozen_string_literal: true

class ExecutionNodeResult < ApplicationRecord
  include Code0::ZeroTrack::Database::Partitioning::PartitionedTable
  include TruncateTimePrecision

  partition_by :created_at, strategy: :daily, retain_for: 1.month
  truncate_time_precision :created_at

  self.table_name = 'p_execution_node_results'
  self.primary_key = %i[id created_at]

  belongs_to :execution_result, foreign_key: %i[execution_result_id created_at], inverse_of: :node_results
  belongs_to :node_function, optional: true
  belongs_to :function_definition, optional: true

  has_many :parameter_results,
           class_name: 'ExecutionParameterResult',
           foreign_key: %i[execution_node_result_id created_at],
           inverse_of: :execution_node_result

  validates :position, presence: true, numericality: { only_integer: true }
  validates :started_at, :finished_at, numericality: { only_integer: true }
  validate :only_one_execution_target_present
  validate :only_one_result_present

  private

  def only_one_execution_target_present
    return if [node_function.present?, function_definition.present?].count(true) == 1

    errors.add(:base, 'Only one of node_function or function_definition must be present')
  end

  def only_one_result_present
    return if [!success.nil?, !error.nil?].count(true) <= 1

    errors.add(:base, 'Only one of success or error can be present')
  end
end
