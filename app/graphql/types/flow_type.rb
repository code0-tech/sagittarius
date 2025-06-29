# frozen_string_literal: true

module Types
  class FlowType < Types::BaseObject
    description 'Represents a flow'

    authorize :read_flow

    # field :name, String, null: false does exist in pictor but not in grpc
    field :input_type, Types::DataTypeType, null: true, description: 'The input data type of the flow'
    field :return_type, Types::DataTypeType, null: true, description: 'The return data type of the flow'
    field :settings, [Types::FlowSettingType], null: true, method: :flow_settings,
                                               description: 'The settings of the flow'
    field :starting_node, Types::NodeFunctionType, null: false, description: 'The starting node of the flow'
    field :type, Types::FlowTypeType, null: false, description: 'The flow type of the flow', method: :flow_type

    id_field Flow
    timestamps
  end
end
