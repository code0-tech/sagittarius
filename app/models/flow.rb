# frozen_string_literal: true

class Flow < ApplicationRecord
  belongs_to :project, class_name: 'NamespaceProject'
  belongs_to :flow_type
  belongs_to :input_type, class_name: 'DataType', optional: true
  belongs_to :return_type, class_name: 'DataType', optional: true
  belongs_to :starting_node, class_name: 'NodeFunction'

  has_many :flow_settings, class_name: 'FlowSetting', inverse_of: :flow

  validates :name, presence: true,
            allow_blank: false,
            uniqueness: { case_sensitive: false, scope: :project_id }

  def to_grpc
    Tucana::Shared::ValidationFlow.new(
      flow_id: id,
      project_id: project.id,
      type: flow_type.identifier,
      data_types: [], # TODO: when data types are creatable
      input_type_identifier: input_type&.identifier,
      return_type_identifier: return_type&.identifier,
      settings: flow_settings.map(&:to_grpc),
      starting_node_id: starting_node.id,
      node_functions: collect_node_functions.map(&:to_grpc)
    )
  end

  def collect_node_functions
    sql = <<-SQL
        WITH RECURSIVE node_function_tree AS (
          SELECT *
          FROM node_functions
          WHERE id = ? -- base case
          UNION ALL
          SELECT nf.*
          FROM node_functions nf
            INNER JOIN node_function_tree nf_tree
              ON nf.id = nf_tree.next_node_id
        )

        SELECT DISTINCT * FROM node_function_tree ORDER BY id
    SQL

    NodeFunction.find_by_sql([sql, starting_node_id])
  end
end
