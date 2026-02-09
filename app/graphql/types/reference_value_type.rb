# frozen_string_literal: true

module Types
  class ReferenceValueType < Types::BaseObject
    description 'Represents a reference value in the system.'

    field :node_function_id, GlobalIdType[::NodeFunction], null: false, description: 'The referenced value.'

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
