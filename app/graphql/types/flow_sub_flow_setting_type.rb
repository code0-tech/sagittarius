# frozen_string_literal: true

module Types
  class FlowSubFlowSettingType < Types::BaseObject
    description 'Represents a sub-flow setting.'

    field :default_value, GraphQL::Types::JSON,
          null: true,
          description: 'The default value of the sub-flow setting.'
    field :hidden, Boolean,
          null: true,
          description: 'Whether the sub-flow setting is hidden.'
    field :identifier, String,
          null: false,
          description: 'The identifier of the sub-flow setting.'
    field :optional, Boolean,
          null: true,
          description: 'Whether the sub-flow setting is optional.'
  end
end
