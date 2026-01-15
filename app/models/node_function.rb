# frozen_string_literal: true

class NodeFunction < ApplicationRecord
  belongs_to :function_definition, inverse_of: :node_functions
  belongs_to :next_node, class_name: 'NodeFunction', optional: true
  belongs_to :flow, class_name: 'Flow'

  has_one :previous_node,
          class_name: 'NodeFunction',
          foreign_key: :next_node_id,
          inverse_of: :next_node

  has_many :node_parameter_values,
           class_name: 'NodeParameter',
           inverse_of: :function_value

  has_many :node_parameters,
           class_name: 'NodeParameter',
           inverse_of: :node_function,
           dependent: :destroy,
           autosave: true

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
    Tucana::Shared::NodeFunction.new(
      database_id: id,
      runtime_function_id: function_definition.runtime_function_definition.runtime_name,
      parameters: node_parameters.map(&:to_grpc),
      next_node_id: next_node&.id
    )
  end
end
