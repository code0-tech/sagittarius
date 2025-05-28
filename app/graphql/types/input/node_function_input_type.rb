# frozen_string_literal: true

module Types
  module Input
    class NodeFunctionInputType < Types::BaseInputObject
      description 'Input type for a Node Function'

      argument :runtime_function_id, Types::GlobalIdType[::RuntimeFunctionDefinition],
               required: true, description: 'The identifier of the Runtime Function Definition'

      argument :next_node, Types::Input::NodeFunctionInputType, required: false,
                                                         description: 'The next Node Function in the flow'
      argument :parameters, [Types::Input::NodeParameterInputType], required: true,
                                                             description: 'The parameters of the Node Function'
    end
  end
end
