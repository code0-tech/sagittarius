# frozen_string_literal: true

module Types
  module Input
    class ReferenceValueInputType < Types::BaseInputObject
      description 'Input type for reference value'

      argument :data_type_identifier, Types::Input::DataTypeIdentifierInputType,
               required: true, description: 'The identifier of the data type this reference value belongs to'
      argument :primary_level, Int, required: true,
                                    description: 'The primary level of the reference value'
      argument :reference_path, [Types::Input::ReferencePathInputType],
               required: true, description: 'The paths associated with this reference value'
      argument :secondary_level, Int, required: true,
                                      description: 'The secondary level of the reference value'
      argument :tertiary_level, Int, required: false,
                                     description: 'The tertiary level of the reference value'
    end
  end
end
