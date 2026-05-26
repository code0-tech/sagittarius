# frozen_string_literal: true

module Types
  class RuntimeFlowTypeSettingType < Types::BaseObject
    description 'Represents a runtime flow type setting'

    authorize :read_runtime_flow_type_setting

    field :default_value, GraphQL::Types::JSON, null: true,
                                                description: 'Default value of the runtime flow type setting'
    field :descriptions, [Types::TranslationType], null: false,
                                                   description: 'Descriptions of the runtime flow type setting'
    field :hidden, Boolean, null: false, description: 'Indicates if the runtime flow type setting is hidden'
    field :identifier, String, null: false, description: 'Identifier of the runtime flow type setting'
    field :names, [Types::TranslationType], null: false, description: 'Names of the runtime flow type setting'
    field :optional, Boolean, null: false, description: 'Indicates if the runtime flow type setting is optional'
    field :removed_at, Types::TimeType, null: true, description: 'The timestamp when this setting was soft removed'
    field :runtime_flow_type, Types::RuntimeFlowTypeType, null: false,
                                                          description: 'Runtime flow type of this setting'
    field :unique, String, null: false, description: 'Unique scope of the runtime flow type setting'

    id_field RuntimeFlowTypeSetting
    timestamps
  end
end
