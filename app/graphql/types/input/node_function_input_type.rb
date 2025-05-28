# frozen_string_literal: true

module Types
  module Input
    class NodeFunctionInputType < Types::BaseInputObject
      description 'Input type for a Node Function'

      argument :function, Types::Input::NodeFunctionDefinitionInputType, required: true,
                                                                  description: 'The definition of the Node Function'
      argument :next_node, Types::Input::NodeFunctionInputType, required: false,
                                                         description: 'The next Node Function in the flow'
      argument :parameters, [Types::Input::NodeParameterInputType], required: true,
                                                             description: 'The parameters of the Node Function'
    end
  end
end
