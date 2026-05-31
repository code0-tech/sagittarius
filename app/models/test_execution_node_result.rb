# frozen_string_literal: true

class TestExecutionNodeResult < ApplicationRecord
  belongs_to :test_execution, inverse_of: :node_results
  belongs_to :node_function, optional: true

  has_many :parameter_results,
           class_name: 'TestExecutionParameterResult',
           inverse_of: :test_execution_node_result,
           dependent: :destroy

  validates :position, presence: true, numericality: { only_integer: true }
  validates :node_id, presence: true, numericality: { only_integer: true }
  validate :only_one_result_present

  private

  def only_one_result_present
    return if [!success.nil?, !error.nil?].count(true) <= 1

    errors.add(:base, 'Only one of success or error must be present')
  end
end
