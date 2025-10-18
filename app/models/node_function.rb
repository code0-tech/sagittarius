# frozen_string_literal: true

class NodeFunction < ApplicationRecord
  belongs_to :runtime_function, class_name: 'RuntimeFunctionDefinition'
  belongs_to :next_node, class_name: 'NodeFunction', optional: true

  has_one :previous_node, class_name: 'NodeFunction', foreign_key: :next_node_id, inverse_of: :next_node
  has_one :flow, class_name: 'Flow', inverse_of: :starting_node

  has_many :node_parameter_values, class_name: 'NodeParameter', inverse_of: :function_value
  has_many :node_parameters, class_name: 'NodeParameter', inverse_of: :node_function

  validate :validate_recursion, if: :next_node_changed?

  def resolve_flow
    sql = <<-SQL
        WITH RECURSIVE node_function_tree AS (
          SELECT *
          FROM node_functions
          WHERE id = ? -- base case
          UNION ALL
          SELECT nf.*
          FROM node_functions nf
            INNER JOIN node_function_tree nf_tree
              ON nf.next_node_id = nf_tree.id
        )

        SELECT f.*
        FROM flows f
        WHERE f.starting_node_id IN (
          SELECT id FROM node_function_tree
        )
        ORDER BY f.id
    SQL

    flows = Flow.find_by_sql([sql, id])

    raise 'Multiple flows found' if flows.count > 1

    flows.first
  end

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
      runtime_function_id: runtime_function.runtime_name,
      parameters: node_parameters.map(&:to_grpc),
      next_node_id: next_node&.id
    )
  end
end
