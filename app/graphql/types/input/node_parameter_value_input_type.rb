# frozen_string_literal: true

module Types
  module Input
    class NodeParameterValueInputType < Types::BaseInputObject
      description 'Input type for parameter value'

      argument :literal_value, GraphQL::Types::JSON,
               required: false, description: 'The literal value of the parameter'
      argument :reference_value, Types::Input::ReferenceValueInputType,
               required: false, description: 'The reference value of the parameter'
      argument :sub_flow_value, Types::Input::SubFlowValueInputType,
               required: false, description: 'The sub-flow value of the parameter'

      require_one_of %i[literal_value reference_value sub_flow_value]
    end
  end
end
