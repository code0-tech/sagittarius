# frozen_string_literal: true

module Types
  module Input
    class ReferenceValueInputType < Types::BaseInputObject
      description 'Input type for reference value'

      argument :reference_path, [Types::Input::ReferencePathInputType],
               required: true, description: 'The paths associated with this reference value'

      argument :node_function, GlobalIdType[::NodeFunction], required: true, description: 'The referenced value'

      argument :data_type_identifier, Types::Input::DataTypeIdentifierInputType,
               required: true, description: 'The identifier of the data type this reference value belongs to'

      argument :depth, Int, required: true, description: 'The depth of the reference value'
      argument :node, Int, required: true, description: 'The node of the reference'
      argument :scope, [Int], required: true, description: 'The scope of the reference value'
    end
  end
end
