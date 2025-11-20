# frozen_string_literal: true

module Types
  module Input
    class FlowSettingInputType < Types::BaseInputObject
      description 'Input type for flow settings'

      argument :flow_setting_identifier, String, required: true,
                                                 description: 'The identifier (not database id) of the flow setting'

      argument :value, GraphQL::Types::JSON, required: true,
                                             description: 'The value of the flow setting'
    end
  end
end
