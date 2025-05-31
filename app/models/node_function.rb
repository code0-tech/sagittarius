# frozen_string_literal: true

class NodeFunction < ApplicationRecord
  belongs_to :runtime_function, class_name: 'RuntimeFunctionDefinition'
  belongs_to :next_node, class_name: 'NodeFunction', optional: true

  has_many :node_parameter_values, class_name: 'NodeParameter', inverse_of: :function_value
  has_many :node_parameters, class_name: 'NodeParameter', inverse_of: :node_function
  has_many :flows, class_name: 'Flow', inverse_of: :starting_node

  validate :validate_recursion, if: :next_node_changed?

  def validate_recursion
    current_node = self
    until current_node.next_node.nil?
      current_node = current_node.next_node

      if current_node == self
        errors.add(:next_node, :recursion)
        break
      end
    end
  end

  def to_grpc
    Tucana::NodeFunction.new(
      data_base_id: id,
      runtime_function: runtime_function.to_grpc,
      parameters: node_parameters.map(&:to_grpc),
      next_node: next_node&.to_grpc
    )
  end
end
