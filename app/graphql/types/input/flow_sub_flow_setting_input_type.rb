# frozen_string_literal: true

module Types
  module Input
    class FlowSubFlowSettingInputType < Types::BaseInputObject
      description 'Input type for sub-flow settings'

      argument :default_value, GraphQL::Types::JSON,
               required: false,
               description: 'The default value of the sub-flow setting'
      argument :hidden, Boolean,
               required: false,
               description: 'Whether the sub-flow setting is hidden'
      argument :identifier, String,
               required: true,
               description: 'The identifier of the sub-flow setting'
      argument :optional, Boolean,
               required: false,
               description: 'Whether the sub-flow setting is optional'
    end
  end
end
