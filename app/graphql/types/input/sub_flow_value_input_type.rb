# frozen_string_literal: true

module Types
  module Input
    class SubFlowValueInputType < Types::BaseInputObject
      description 'Input type for sub-flow parameter values'

      argument :description, String,
               required: false,
               description: 'The sub-flow description'
      argument :function_identifier, String,
               required: false,
               description: 'The function identifier to execute'
      argument :name, String,
               required: false,
               description: 'The sub-flow name'
      argument :parameters, [Types::Input::SubFlowValueParameterInputType],
               required: false,
               description: 'The sub-flow parameters'
      argument :signature, String,
               required: true,
               description: 'The sub-flow signature'
      argument :starting_node_id, Types::GlobalIdType[::NodeFunction],
               required: false,
               description: 'The starting node to execute'

      require_one_of %i[starting_node_id function_identifier]
    end
  end
end
