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
    grpc_sub_flow = Tucana::Shared::SubFlow.new(
      starting_node_id: starting_node_id,
      signature: signature,
      settings: sub_flow_settings.map(&:to_grpc)
    )
    if function_definition.present?
      function_args = { function_identifier: function_identifier }
      definition_source = function_definition.runtime_function_definition.definition_source
      function_args[:definition_source] = definition_source if definition_source.present?

      grpc_sub_flow.function = Tucana::Shared::SubFlowFunction.new(**function_args)
    end

    grpc_sub_flow
  end

  private

  def validate_execution_reference
    return if [starting_node.present?, function_definition.present?].count(true) == 1

    errors.add(:base, 'Exactly one of starting_node or function_definition must be present')
  end
end
