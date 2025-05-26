# frozen_string_literal: true

class NodeFunction < ApplicationRecord
  belongs_to :runtime_function, class_name: 'RuntimeFunctionDefinition'
  belongs_to :next_node, class_name: 'NodeFunction', optional: true

  has_many :node_parameters, inverse_of: :function_value
end
