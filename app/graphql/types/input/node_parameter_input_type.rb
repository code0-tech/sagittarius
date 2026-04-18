# frozen_string_literal: true

module Types
  module Input
    class NodeParameterInputType < Types::BaseInputObject
      description 'Input type for Node parameter'

      argument :value, Types::Input::NodeParameterValueInputType, required: true,
                                                                  description: 'The value of the parameter'
    end
  end
end
