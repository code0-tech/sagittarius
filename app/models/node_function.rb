# frozen_string_literal: true

class NodeFunction < ApplicationRecord
  belongs_to :runtime_function, class_name: 'RuntimeFunctionDefinition'
  belongs_to :next_node, class_name: 'NodeFunction', optional: true

  has_many :node_parameters, inverse_of: :function_value

  def to_grpc
    Tucana::NodeFunction.new(
      data_base_id: id,
      runtime_function: runtime_function.to_grpc,
      parameters: node_parameters.map(&:to_grpc),
      next_node: next_node&.to_grpc
    )
  end
end
