# frozen_string_literal: true

module Types
  module Input
    class NodeParameterInputType < Types::BaseInputObject
      description 'Input type for Node parameter'

      argument :parameter_definition_id, Types::GlobalIdType[::ParameterDefinition],
               required: true, description: 'The identifier of the Parameter Definition'

      argument :value, Types::Input::NodeParameterValueInputType, required: true,
                                                                  description: 'The value of the parameter'
    end
  end
end
