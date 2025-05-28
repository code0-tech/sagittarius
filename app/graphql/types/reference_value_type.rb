# frozen_string_literal: true

module Types
  class ReferenceValueType < Types::BaseObject
    description 'Represents a reference value in the system.'

    authorize :read_flow

    field :data_type_identifier, Types::DataTypeIdentifierType,
          null: false, description: 'The identifier of the data type this reference value belongs to.'

    field :primary_level, Int, null: false, description: 'The primary level of the reference value.'
    field :secondary_level, Int, null: false, description: 'The secondary level of the reference value.'
    field :tertiary_level, Int, null: true, description: 'The tertiary level of the reference value, if applicable.'

    field :reference_path, [Types::ReferencePathType], null: false,
                                                       description: 'The paths associated with this reference value.'

    id_field ReferenceValue
    timestamps
  end
end
