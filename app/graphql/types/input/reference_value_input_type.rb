# frozen_string_literal: true

module Types
  module Input
    class ReferenceValueInputType < Types::BaseInputObject
      description 'Input type for reference value'

      argument :reference_path, [Types::Input::ReferencePathInputType],
               required: true, description: 'The paths associated with this reference value'

      argument :node_function_id, GlobalIdType[::NodeFunction], required: true, description: 'The referenced value'
    end
  end
end
