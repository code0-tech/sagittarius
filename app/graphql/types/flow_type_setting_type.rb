# frozen_string_literal: true

module Types
  class FlowTypeSettingType < Types::BaseObject
    description 'Represents a flow type setting'

    authorize :read_flow_type_setting

    field :descriptions, [Types::TranslationType], null: false,
                                                   description: 'Descriptions of the flow type setting'
    field :flow_type, Types::FlowTypeType, null: true, description: 'Flow type of the flow type setting'
    field :identifier, String, null: false, description: 'Identifier of the flow type setting'
    field :names, [Types::TranslationType], null: false, description: 'Names of the flow type setting'
    field :type, String, null: false, description: 'Type of the flow type setting'
    field :unique, Boolean, null: false, description: 'Unique status of the flow type setting'

    field :referenced_data_types, Types::DataTypeType.connection_type,
          null: false,
          description: 'The data types that are referenced in this flow type setting'

    id_field FlowTypeSetting
    timestamps

    def referenced_data_types
      DataTypesFinder.new({ flow_type_setting: object, expand_recursively: true }).execute
    end
  end
end
