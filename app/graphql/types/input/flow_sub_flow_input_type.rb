# frozen_string_literal: true

module Types
  module Input
    class FlowSubFlowInputType < Types::BaseInputObject
      description 'Input type for sub-flow parameter values'

      argument :function_identifier, String,
               required: false,
               description: 'The function identifier to execute'
      argument :settings, [Types::Input::FlowSubFlowSettingInputType],
               required: false,
               description: 'The sub-flow settings'
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
