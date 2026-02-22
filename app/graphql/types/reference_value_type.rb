# frozen_string_literal: true

module Types
  class ReferenceValueType < Types::BaseObject
    description 'Represents a reference value in the system.'

    field :node_function_id, GlobalIdType[::NodeFunction],
          null: true,
          description: 'The referenced value unless referencing the flow input.'

    field :reference_path, [Types::ReferencePathType],
          null: false,
          description: 'The paths associated with this reference value.',
          method: :reference_paths

    field :parameter_index, GraphQL::Types::Int,
          null: true,
          description: 'The index of the referenced parameter'

    field :input_index, GraphQL::Types::Int,
          null: true,
          description: 'The index of the referenced input'

    id_field ReferenceValue
    timestamps

    def node_function_id
      object.node_function&.to_global_id
    end
  end
end
