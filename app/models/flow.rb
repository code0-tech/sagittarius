# frozen_string_literal: true

class Flow < ApplicationRecord
  belongs_to :project, class_name: 'NamespaceProject'
  belongs_to :flow_type
  belongs_to :input_type, class_name: 'DataType', optional: true
  belongs_to :return_type, class_name: 'DataType', optional: true
  belongs_to :starting_node, class_name: 'NodeFunction'

  has_many :flow_settings, class_name: 'FlowSetting', inverse_of: :flow

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
      node_functions: collect_node_functions
    )
  end

  private

  def collect_node_functions
    current_node = starting_node
    nodes = []
    until current_node.nil?
      nodes << current_node.to_grpc
      current_node = current_node.next_node
    end
    nodes
  end
end
