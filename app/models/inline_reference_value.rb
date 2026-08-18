# frozen_string_literal: true

class InlineReferenceValue < ApplicationRecord
  include NodeValueOwner

  belongs_to :node_parameter, inverse_of: :inline_reference_values, optional: true
  belongs_to :parent_inline_reference_value, class_name: 'InlineReferenceValue', optional: true,
                                             inverse_of: :inline_reference_values

  has_many :inline_reference_values, autosave: true, dependent: :destroy,
                                     foreign_key: :parent_inline_reference_value_id,
                                     inverse_of: :parent_inline_reference_value

  validates :signature, presence: true
  validate :validate_owner

  def to_grpc
    node_value = Tucana::Shared::NodeValue.new(literal_value: Tucana::Shared::LiteralValue.new)

    if reference_value.present?
      node_value.reference_value = reference_value.to_grpc
    elsif sub_flow.present?
      node_value.sub_flow = sub_flow.to_grpc
    else
      node_value.literal_value = Tucana::Shared::LiteralValue.new(
        value: Tucana::Shared::Value.from_ruby(literal_value),
        references: inline_reference_values.map(&:to_grpc)
      )
    end

    Tucana::Shared::InlineReferenceValue.new(signature: signature, value: node_value)
  end

  private

  def validate_owner
    return if [node_parameter.present?, parent_inline_reference_value.present?].count(true) == 1

    errors.add(:base, 'Exactly one of node_parameter or parent_inline_reference_value must be present')
  end
end
