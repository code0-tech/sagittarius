# frozen_string_literal: true

module Types
  class FlowSettingType < Types::BaseObject
    description 'Represents a flow setting'

    authorize :read_flow

    field :flow_setting_id, String, null: false, description: 'The identifier of the flow setting'

    field :value, GraphQL::Types::JSON, null: false, method: :object, description: 'The value of the flow setting'

    id_field FlowSetting
    timestamps
  end
end
