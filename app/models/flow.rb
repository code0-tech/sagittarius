# frozen_string_literal: true

class Flow < ApplicationRecord
  belongs_to :project, class_name: 'NamespaceProject'
  belongs_to :flow_type
  belongs_to :starting_node, class_name: 'NodeFunction', optional: true

  has_many :flow_settings, class_name: 'FlowSetting', inverse_of: :flow
  has_many :node_functions, class_name: 'NodeFunction', inverse_of: :flow

  has_many :flow_data_type_links, inverse_of: :flow
  has_many :referenced_data_types, through: :flow_data_type_links, source: :referenced_data_type

  validates :name, presence: true,
                   allow_blank: false,
                   uniqueness: { case_sensitive: false, scope: :project_id }

  validates :input_type, length: { maximum: 2000 }, allow_nil: true
  validates :return_type, length: { maximum: 2000 }, allow_nil: true

  def to_grpc
    Tucana::Shared::ValidationFlow.new(
      flow_id: id,
      project_id: project.id,
      project_slug: project.slug,
      type: flow_type.identifier,
      data_types: [], # TODO: when data types are creatable
      input_type: input_type,
      return_type: return_type,
      settings: flow_settings.map(&:to_grpc),
      starting_node_id: starting_node.id,
      node_functions: node_functions.map(&:to_grpc)
    )
  end
end
