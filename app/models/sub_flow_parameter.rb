# frozen_string_literal: true

class SubFlowParameter < ApplicationRecord
  include NodeValueOwner

  # `sub_flow` (has_one, via NodeValueOwner) is this parameter's nested value, so the
  # containing sub-flow is exposed as `parent_sub_flow` to avoid the name clash.
  belongs_to :parent_sub_flow, class_name: 'SubFlow', foreign_key: :sub_flow_id,
                               inverse_of: :sub_flow_parameters

  has_many :inline_reference_values, autosave: true, dependent: :destroy, inverse_of: :sub_flow_parameter

  validates :identifier, presence: true

  def to_grpc
    Tucana::Shared::SubFlowParameters.new(
      identifier: identifier,
      value: to_grpc_node_value,
      cast: cast
    )
  end
end
