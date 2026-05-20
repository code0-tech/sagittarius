# frozen_string_literal: true

class SubFlow < ApplicationRecord
  belongs_to :node_parameter, inverse_of: :sub_flow
  belongs_to :starting_node, class_name: 'NodeFunction', optional: true

  has_many :sub_flow_settings, inverse_of: :sub_flow, autosave: true, dependent: :destroy

  validate :validate_execution_reference

  def to_grpc
    Tucana::Shared::SubFlow.new(
      starting_node_id: starting_node_id,
      function_identifier: function_identifier,
      signature: signature,
      settings: sub_flow_settings.map(&:to_grpc)
    )
  end

  private

  def validate_execution_reference
    return if [starting_node_id.present?, function_identifier.present?].count(true) == 1

    errors.add(:base, 'Exactly one of starting_node or function_identifier must be present')
  end
end
