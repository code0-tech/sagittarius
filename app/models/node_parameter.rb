# frozen_string_literal: true

class NodeParameter < ApplicationRecord
  include NodeValueOwner

  belongs_to :parameter_definition, inverse_of: :node_parameters
  belongs_to :node_function, class_name: 'NodeFunction', inverse_of: :node_parameters

  has_many :inline_reference_values, autosave: true, dependent: :destroy, inverse_of: :node_parameter

  def to_grpc
    param = Tucana::Shared::NodeParameter.new(
      database_id: id,
      runtime_parameter_id: parameter_definition.runtime_parameter_definition.runtime_name,
      cast: cast
    )

    param.value = to_grpc_node_value

    param
  end
end
