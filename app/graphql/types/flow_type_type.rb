# frozen_string_literal: true

module Types
  class FlowTypeType < Types::BaseObject
    description 'Represents a flow type'

    authorize :read_flow_type

    field :aliases, Types::TranslationType.connection_type, null: true, description: 'Name of the function'
    field :descriptions, Types::TranslationType.connection_type, null: true,
                                                                 description: 'Descriptions of the flow type'
    field :display_messages, Types::TranslationType.connection_type, null: true,
                                                                     description: 'Display message of the function'
    field :editable, Boolean, null: false, description: 'Editable status of the flow type'
    field :flow_type_settings, [Types::FlowTypeSettingType], null: false,
                                                             description: 'Flow type settings of the flow type'
    field :identifier, String, null: false, description: 'Identifier of the flow type'
    field :input_type, Types::DataTypeType, null: true, description: 'Input type of the flow type'
    field :names, Types::TranslationType.connection_type, null: true, description: 'Names of the flow type'
    field :return_type, Types::DataTypeType, null: true, description: 'Return type of the flow type'

    id_field FlowType
    timestamps
  end
end
