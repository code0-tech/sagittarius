# frozen_string_literal: true

module Types
  module Input
    class NodeFunctionInputType < Types::BaseInputObject
      description 'Input type for a Node Function'

      argument :id, Types::GlobalIdType[::NodeFunction],
               required: true, description: 'The identifier of the Node Function used to create/update the flow'

      argument :function_definition_id, Types::GlobalIdType[::FunctionDefinition],
               required: true, description: 'The identifier of the Function Definition'

      argument :next_node_id, Types::GlobalIdType[::NodeFunction], required: false,
                                                                   description: 'The next Node Function in the flow'
      argument :parameters, [Types::Input::NodeParameterInputType], required: true,
                                                                    description: 'The parameters of the Node Function'
    end
  end
end
