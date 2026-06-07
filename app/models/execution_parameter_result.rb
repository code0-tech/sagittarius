# frozen_string_literal: true

class ExecutionParameterResult < ApplicationRecord
  belongs_to :execution_node_result, inverse_of: :parameter_results

  validates :position, presence: true, numericality: { only_integer: true }
  validate :value_must_be_present

  private

  def value_must_be_present
    errors.add(:value, "can't be blank") if value.nil?
  end
end
