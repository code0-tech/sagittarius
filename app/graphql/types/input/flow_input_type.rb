# frozen_string_literal: true

module Types
  module Input
    class FlowInputType < Types::BaseInputObject
      description 'Input type for creating or updating a flow'

      argument :settings, [Types::Input::FlowSettingInputType], required: false,
                                                                description: 'The settings of the flow'
      argument :starting_node, Types::Input::NodeFunctionInputType, required: true,
                                                                    description: 'The starting node of the flow'
      argument :type, Types::GlobalIdType[::FlowType], required: true,
                                                       description: 'The identifier of the flow type'
    end
  end
end
