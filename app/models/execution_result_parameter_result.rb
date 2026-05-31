# frozen_string_literal: true

class ExecutionResultParameterResult < ApplicationRecord
  belongs_to :execution_result_node_result, inverse_of: :parameter_results

  validates :position, presence: true, numericality: { only_integer: true }
  validates :value, presence: true
end
