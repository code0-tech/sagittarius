# frozen_string_literal: true

module Types
  module Input
    class NodeParameterInputType < Types::BaseInputObject
      description 'Input type for Node parameter'

      argument :definition, Types::Input::NodeParameterDefinitionInputType, required: true,
                                                                     description: 'The definition of the parameter'
      argument :value, Types::Input::NodeParameterValueInputType, required: false,
                                                           description: 'The value of the parameter'
    end
  end
end
