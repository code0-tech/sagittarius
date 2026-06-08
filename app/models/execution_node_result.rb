# frozen_string_literal: true

class ExecutionNodeResult < ApplicationRecord
  belongs_to :execution_result, inverse_of: :node_results
  belongs_to :node_function, optional: true
  belongs_to :function_definition, optional: true

  has_many :parameter_results,
           class_name: 'ExecutionParameterResult',
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
    return if [!success.nil?, !error.nil?].count(true) == 1

    errors.add(:base, 'Only one of success or error must be present')
  end
end
