# frozen_string_literal: true

module Types
  module Input
    class FlowSettingInputType < Types::BaseInputObject
      description 'Input type for flow settings'

      argument :flow_setting_id, String, required: true,
                                              description: 'The identifier (not database id) of the flow setting'

      argument :object, GraphQL::Types::JSON, required: true,
                                             description: 'The value of the flow setting'
    end
  end
end
