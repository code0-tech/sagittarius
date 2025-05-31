# frozen_string_literal: true

module Types
  class FlowType < Types::BaseObject
    description 'Represents a flow'

    authorize :read_flow

    # field :name, String, null: false does exist in pictor but not in grpc
    field :settings, [Types::FlowSettingType], null: true, method: :flow_settings,
                                               description: 'The settings of the flow'
    field :starting_node, Types::NodeFunctionType, null: false, description: 'The starting node of the flow'
    field :type, String, null: false, description: 'The identifier of the flow type' # identifier of the flow_type

    def type
      object.flow_type.identifier
    end

    id_field Flow
    timestamps
  end
end
