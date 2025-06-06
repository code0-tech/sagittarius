# frozen_string_literal: true

module Types
  class FlowType < Types::BaseObject
    description 'Represents a flow'

    authorize :read_flow

    field :flow_id, Types::GlobalIdType[::Flow], null: false, description: 'The global ID of the flow'
    # field :name, String, null: false does exist in pictor but not in grpc
    field :input_type, Types::DataTypeType, null: true, description: 'The input data type of the flow'
    field :return_type, Types::DataTypeType, null: true, description: 'The return data type of the flow'
    field :settings, [Types::FlowSettingType], null: true, method: :flow_settings,
                                               description: 'The settings of the flow'
    field :starting_node, Types::NodeFunctionType, null: false, description: 'The starting node of the flow'
    field :type, String, null: false, description: 'The identifier of the flow type' # identifier of the flow_type

    def flow_id
      object.id.to_global_id.to_s
    end

    def type
      object.flow_type.identifier
    end

    id_field Flow
    timestamps
  end
end
