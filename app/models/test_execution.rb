# frozen_string_literal: true

class TestExecution < ApplicationRecord
  belongs_to :flow, inverse_of: :test_executions

  has_many :node_results,
           class_name: 'TestExecutionNodeResult',
           inverse_of: :test_execution,
           dependent: :destroy

  validates :execution_identifier, presence: true,
                                   allow_blank: false,
                                   uniqueness: { case_sensitive: false, scope: :flow_id }
  validate :only_one_result_present

  private

  def only_one_result_present
    return if [!success.nil?, !error.nil?].count(true) <= 1

    errors.add(:base, 'Only one of success or error must be present')
  end
end
