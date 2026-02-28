# frozen_string_literal: true

module Types
  class FlowType < Types::BaseObject
    description 'Represents a flow'

    authorize :read_flow

    field :name, String, null: false, description: 'Name of the flow'

    field :disabled_reason, String,
          null: true,
          description: 'The reason why the flow is disabled, if it is disabled'

    field :input_type, Types::DataTypeType,
          null: true,
          description: 'The input data type of the flow'
    field :project, Types::NamespaceProjectType,
          null: false,
          description: 'The project the flow belongs to'
    field :return_type, Types::DataTypeType,
          null: true,
          description: 'The return data type of the flow'
    field :settings, Types::FlowSettingType.connection_type,
          null: false,
          method: :flow_settings,
          description: 'The settings of the flow'
    field :starting_node_id, Types::GlobalIdType[::NodeFunction],
          null: true,
          description: 'The ID of the starting node of the flow'
    field :type, Types::FlowTypeType,
          null: false,
          description: 'The flow type of the flow', method: :flow_type

    field :nodes, Types::NodeFunctionType.connection_type,
          null: false,
          description: 'Nodes of the flow',
          method: :node_functions

    expose_abilities %i[
      delete_flow
    ]

    id_field Flow
    timestamps

    def starting_node_id
      object.starting_node&.to_global_id
    end
  end
end
