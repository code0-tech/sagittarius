# frozen_string_literal: true

module Types
  module Input
    class ReferenceValueInputType < Types::BaseInputObject
      description 'Input type for reference value'

      argument :reference_path, [Types::Input::ReferencePathInputType],
               required: true,
               description: 'The paths associated with this reference value'

      argument :node_function_id, GlobalIdType[::NodeFunction],
               required: false,
               description: 'The referenced value unless referencing the flow input'

      argument :parameter_index, GraphQL::Types::Int,
               required: false,
               description: 'The index of the referenced parameter'

      argument :input_index, GraphQL::Types::Int,
               required: false,
               description: 'The index of the referenced input'
    end
  end
end
