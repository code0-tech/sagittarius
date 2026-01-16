# frozen_string_literal: true

module Types
  class ReferenceValueType < Types::BaseObject
    description 'Represents a reference value in the system.'

    field :node_function_id, GlobalIdType[::NodeFunction], null: false, description: 'The referenced value.'

    field :data_type_identifier, Types::DataTypeIdentifierType,
          null: false, description: 'The identifier of the data type this reference value belongs to.'

    field :depth, Int, null: false, description: 'The depth of the reference value.'
    field :node, Int, null: false, description: 'The node of the reference value.'
    field :scope, [Int], null: false, description: 'The scope of the reference value.'

    field :reference_path, [Types::ReferencePathType],
          null: false,
          description: 'The paths associated with this reference value.',
          method: :reference_paths

    id_field ReferenceValue
    timestamps

    def node_function_id
      object.node_function.to_global_id
    end
  end
end
