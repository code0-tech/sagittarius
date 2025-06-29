# frozen_string_literal: true

module Types
  class NodeFunctionDefinitionType < Types::BaseObject
    description 'Represents a Node Function definition'

    authorize :read_flow

    field :function_id, String, null: false, description: 'The function ID of the Node Function'
    field :runtime_function_id, String, null: false, description: 'The runtime function ID of the Node Function'

    timestamps
  end
end
