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

    param.value = Tucana::Shared::NodeValue.new(literal_value: Tucana::Shared::LiteralValue.new)

    if reference_value.present?
      param.value.reference_value = reference_value.to_grpc
    elsif sub_flow.present?
      param.value.sub_flow = sub_flow.to_grpc
    else
      param.value.literal_value = Tucana::Shared::LiteralValue.new(
        value: Tucana::Shared::Value.from_ruby(literal_value),
        references: inline_reference_values.map(&:to_grpc)
      )
    end

    param
  end
end
