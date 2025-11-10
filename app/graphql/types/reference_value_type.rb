# frozen_string_literal: true

module Types
  class ReferenceValueType < Types::BaseObject
    description 'Represents a reference value in the system.'

    authorize :read_flow

    field :data_type_identifier, Types::DataTypeIdentifierType,
          null: false, description: 'The identifier of the data type this reference value belongs to.'

    field :node_function, Types::NodeFunctionType, null: false, description: 'The referenced value.'

    field :reference_path, [Types::ReferencePathType], null: false,
                                                       description: 'The paths associated with this reference value.'

    id_field ReferenceValue
    timestamps
  end
end
