# frozen_string_literal: true

module Types
  module Input
    class NodeFunctionDefinitionInputType < Types::BaseInputObject
      description 'Input type for Node Function definition'

      argument :function_id, String, required: true,
                                     description: 'The function ID of the Node Function'
      argument :runtime_function_id, String, required: true,
                                             description: 'The runtime function ID of the Node Function'
    end
  end
end
