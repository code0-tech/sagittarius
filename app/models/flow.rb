# frozen_string_literal: true

class Flow < ApplicationRecord
  belongs_to :project, class_name: 'NamespaceProject'
  belongs_to :flow_type
  belongs_to :input_type_identifier, class_name: 'DataTypeIdentifier', optional: true
  belongs_to :return_type_identifier, class_name: 'DataTypeIdentifier', optional: true
  belongs_to :starting_node, class_name: 'NodeFunction'

  has_many :flow_settings

  def to_grpc
    Tucana::Shared::Flow.new(
      id: id,
      project_id: project.id,
      flow_type_id: flow_type.identifier,
      data_types: [], # TODO
      input_type_id: input_type_identifier&.identifier,
      return_type_id: return_type_identifier&.identifier,
      settings: flow_settings.map(&:to_grpc),
      starting_node: starting_node.to_grpc
    )
  end
end
