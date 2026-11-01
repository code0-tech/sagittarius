# frozen_string_literal: true

module Types
  module Input
    class SubFlowValueParameterInputType < Types::BaseInputObject
      description 'Input type for sub-flow parameters'

      argument :cast, String,
               required: false,
               description: 'The cast applied to the sub-flow parameter'
      argument :identifier, String,
               required: true,
               description: 'The identifier of the sub-flow parameter'
      argument :value, Types::Input::NodeParameterValueInputType,
               required: true,
               description: 'The value of the sub-flow parameter'
    end
  end
end
