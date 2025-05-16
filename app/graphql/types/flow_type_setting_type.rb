# frozen_string_literal: true

module Types
  class FlowTypeSettingType < Types::BaseObject
    description 'Represents a flow type setting'

    authorize :read_flow_type_setting

    field :data_type, Types::DataTypeType, null: true, description: 'Data type of the flow type setting'
    field :descriptions, Types::TranslationType.connection_type, null: true,
                                                                 description: 'Descriptions of the flow type setting'
    field :flow_type, Types::FlowTypeType, null: true, description: 'Flow type of the flow type setting'
    field :identifier, String, null: false, description: 'Identifier of the flow type setting'
    field :names, Types::TranslationType.connection_type, null: true, description: 'Names of the flow type setting'
    field :unique, Boolean, null: false, description: 'Unique status of the flow type setting'
  end
end
