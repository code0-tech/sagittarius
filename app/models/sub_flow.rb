# frozen_string_literal: true

class SubFlow < ApplicationRecord
  belongs_to :node_parameter, inverse_of: :sub_flow
  belongs_to :starting_node, class_name: 'NodeFunction', optional: true
  belongs_to :function_definition, optional: true

  has_many :sub_flow_settings, inverse_of: :sub_flow, autosave: true

  validate :validate_execution_reference

  def function_identifier
    function_definition&.identifier
  end

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
    return if [starting_node.present?, function_definition.present?].count(true) == 1

    errors.add(:base, 'Exactly one of starting_node or function_definition must be present')
  end
end
