# frozen_string_literal: true

module Types
  class NodeFunctionType < Types::BaseObject
    description 'Represents a Node Function'

    authorize :read_flow

    field :next_node_id, Types::GlobalIdType[::NodeFunction],
          null: true,
          description: 'The ID of the next Node Function in the flow'
    field :parameters, Types::NodeParameterType.connection_type,
          null: false,
          method: :node_parameters,
          description: 'The parameters of the Node Function'
    field :runtime_function, Types::RuntimeFunctionDefinitionType,
          null: false,
          description: 'The definition of the Node Function'

    id_field NodeFunction
    timestamps

    def next_node_id
      object.next_node&.to_global_id
    end
  end
end
