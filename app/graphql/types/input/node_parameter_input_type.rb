# frozen_string_literal: true

module Types
  module Input
    class NodeParameterInputType < Types::BaseInputObject
      description 'Input type for Node parameter'

      argument :runtime_parameter_definition_id, Types::GlobalIdType[::RuntimeParameterDefinition],
                required: true, description: 'The identifier of the Runtime Parameter Definition'

      argument :value, Types::Input::NodeParameterValueInputType, required: false,
                                                           description: 'The value of the parameter'
    end
  end
end
