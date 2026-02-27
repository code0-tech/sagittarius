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
      parameters: ordered_parameters.map(&:to_grpc),
      next_node_id: next_node&.id
    )
  end

  def ordered_parameters
    fd = FunctionDefinition.arel_table
    rfd = RuntimeFunctionDefinition.arel_table
    rpd = RuntimeParameterDefinition.arel_table
    np = NodeParameter.arel_table
    pd = ParameterDefinition.arel_table

    NodeParameter
      .from(fd)
      .joins(
        fd
          .join(rfd, Arel::Nodes::InnerJoin)
          .on(fd[:runtime_function_definition_id].eq(rfd[:id]))
          .join(rpd, Arel::Nodes::InnerJoin)
          .on(rfd[:id].eq(rpd[:runtime_function_definition_id]))
          .join(pd, Arel::Nodes::InnerJoin)
          .on(rpd[:id].eq(pd[:runtime_parameter_definition_id]))
          .join(np, Arel::Nodes::InnerJoin)
          .on(np[:parameter_definition_id].eq(pd[:id]))
          .join_sources
      )
      .where(fd[:id].eq(function_definition_id))
      .where(np[:node_function_id].eq(id))
      .order(rpd[:id].asc)
      .select(np[Arel.star])
  end
end
