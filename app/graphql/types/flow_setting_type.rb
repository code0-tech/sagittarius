# frozen_string_literal: true

module Types
  class FlowSettingType < Types::BaseObject
    description 'Represents a flow setting'

    authorize :read_flow

    field :cast, String,
          null: true,
          description: 'The cast applied to the flow setting'

    field :flow_setting_identifier, String,
          null: false,
          method: :flow_setting_id,
          description: 'The identifier of the flow setting'

    field :value, GraphQL::Types::JSON,
          null: true,
          method: :object,
          description: 'The value of the flow setting'

    id_field FlowSetting
    timestamps
  end
end
