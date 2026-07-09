# frozen_string_literal: true

module Types
  class FlowValidationDiagnosticType < Types::BaseObject
    description 'Represents a diagnostic returned by flow validation'

    field :code, Integer, null: true, description: 'Diagnostic code returned by the validator'
    field :message, String, null: true, description: 'Human-readable diagnostic message'
    field :node_id, Types::GlobalIdType[::NodeFunction],
          null: true,
          description: 'ID of the node that caused the diagnostic'
    field :parameter_index, Integer, null: true, description: 'Index of the parameter that caused the diagnostic'
    field :severity, String, null: true, description: 'Diagnostic severity returned by the validator'

    def node_id
      node_id = object[:node_id] || object['node_id']
      return if node_id.nil?

      Sagittarius::Utils.generated_global_id(node_id, ::NodeFunction)
    end
  end
end
