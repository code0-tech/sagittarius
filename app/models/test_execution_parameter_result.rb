# frozen_string_literal: true

class TestExecutionParameterResult < ApplicationRecord
  belongs_to :test_execution_node_result, inverse_of: :parameter_results

  validates :position, presence: true, numericality: { only_integer: true }
  validates :value, presence: true
end
