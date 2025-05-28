# frozen_string_literal: true

module Types
  module Input
    class NodeParameterDefinitionInputType < Types::BaseInputObject
      description 'Input type for Node parameter definition'

      argument :parameter_id, String, required: true,
                                      description: 'The ID of the parameter'
      argument :runtime_parameter_id, String, required: true,
                                              description: 'The runtime ID of the parameter'
    end
  end
end
