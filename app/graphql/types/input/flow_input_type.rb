# frozen_string_literal: true

module Types
  module Input
    class FlowInputType < Types::BaseInputObject
      description 'Input type for creating or updating a flow'

      argument :input_type, Types::GlobalIdType[::DataType], required: false,
               description: 'The ID of the input data type'
      argument :return_type, Types::GlobalIdType[::DataType], required: false,
               description: 'The ID of the return data type'
      argument :settings, [Types::Input::FlowSettingInputType], required: false,
               description: 'The settings of the flow'
      argument :starting_node, Types::Input::NodeFunctionInputType, required: true,
               description: 'The starting node of the flow'
      argument :type, Types::GlobalIdType[::FlowType], required: true,
               description: 'The identifier of the flow type'
    end
  end
end
