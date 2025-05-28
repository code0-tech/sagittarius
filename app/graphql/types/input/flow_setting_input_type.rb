# frozen_string_literal: true

module Types
  module Input
    class FlowSettingInputType < Types::BaseInputObject
      description 'Input type for flow settings'

      argument :value, GraphQL::Types::JSON, required: true,
                                             description: 'The value of the flow setting'
    end
  end
end
