# frozen_string_literal: true

class InlineReferenceValue < ApplicationRecord
  include NodeValueOwner

  belongs_to :node_parameter, inverse_of: :inline_reference_values, optional: true
  belongs_to :sub_flow_parameter, inverse_of: :inline_reference_values, optional: true
  belongs_to :parent_inline_reference_value, class_name: 'InlineReferenceValue', optional: true,
                                             inverse_of: :inline_reference_values

  has_many :inline_reference_values, autosave: true, dependent: :destroy,
                                     foreign_key: :parent_inline_reference_value_id,
                                     inverse_of: :parent_inline_reference_value

  validates :signature, presence: true
  validate :validate_owner

  def to_grpc
    Tucana::Shared::InlineReferenceValue.new(signature: signature, value: to_grpc_node_value)
  end

  private

  def validate_owner
    owners = [node_parameter.present?, parent_inline_reference_value.present?, sub_flow_parameter.present?]
    return if owners.count(true) == 1

    errors.add(:base,
               'Exactly one of node_parameter, parent_inline_reference_value or sub_flow_parameter must be present')
  end
end
