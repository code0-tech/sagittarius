# frozen_string_literal: true

class ExecutionResult < ApplicationRecord
  attr_readonly :execution_identifier

  belongs_to :flow, inverse_of: :execution_results

  has_many :node_results,
           class_name: 'ExecutionNodeResult',
           inverse_of: :execution_result

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
