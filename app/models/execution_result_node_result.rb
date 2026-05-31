# frozen_string_literal: true

class ExecutionResultNodeResult < ApplicationRecord
  belongs_to :execution_result, inverse_of: :node_results
  belongs_to :node_function

  has_many :parameter_results,
           class_name: 'ExecutionResultParameterResult',
           inverse_of: :execution_result_node_result

  validates :position, presence: true, numericality: { only_integer: true }
  validate :only_one_result_present

  private

  def only_one_result_present
    return if [!success.nil?, !error.nil?].count(true) <= 1

    errors.add(:base, 'Only one of success or error must be present')
  end
end
