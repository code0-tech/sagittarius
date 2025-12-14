# frozen_string_literal: true

module Types
  module Input
    class NodeParameterValueInputType < Types::BaseInputObject
      description 'Input type for parameter value'

      argument :literal_value, GraphQL::Types::JSON,
               required: false, description: 'The literal value of the parameter'
      argument :node_function_id, Types::GlobalIdType[::NodeFunction],
               required: false, description: 'The function value of the parameter as an id'
      argument :reference_value, Types::Input::ReferenceValueInputType,
               required: false, description: 'The reference value of the parameter'

      require_one_of %i[node_function_id literal_value reference_value]
    end
  end
end
