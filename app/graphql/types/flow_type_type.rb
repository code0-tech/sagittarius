# frozen_string_literal: true

module Types
  class FlowTypeType < Types::BaseObject
    description 'Represents a flow type'

    authorize :read_flow_type

    field :descriptions, Types::TranslationType.connection_type, null: true,
                                                                 description: 'Descriptions of the flow type'
    field :editable, Boolean, null: false, description: 'Editable status of the flow type'
    field :flow_type_settings,
          Types::FlowTypeSettingType.connection_type, null: true, description: 'Flow type settings of the flow type'
    field :identifier, String, null: false, description: 'Identifier of the flow type'
    field :input_type, Types::DataTypeType, null: true, description: 'Input type of the flow type'
    field :names, Types::TranslationType.connection_type, null: true, description: 'Names of the flow type'
    field :return_type, Types::DataTypeType, null: true, description: 'Return type of the flow type'
  end
end
