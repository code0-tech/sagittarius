# frozen_string_literal: true

module Types
  class FlowSettingType < Types::BaseObject
    description 'Represents a flow setting'

    authorize :read_flow

    field :database_id, Types::GlobalIdType[::FlowSetting], null: false,
                                                            description: 'The global ID of the flow setting'
    field :value, GraphQL::Types::JSON, null: false, method: :object, description: 'The value of the flow setting'

    def database_id
      object.id.to_global_id.to_s
    end

    id_field FlowSetting
    timestamps
  end
end
