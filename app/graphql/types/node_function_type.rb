# frozen_string_literal: true

module Types
  class NodeFunctionType < Types::BaseObject
    description 'Represents a Node Function'

    authorize :read_flow

    field :identifier, String, null: false, description: 'Identifier of the Node Function'
    field :next_node, Types::NodeFunctionType, null: true, description: 'The next Node Function in the flow'
    field :parameters, Types::NodeParameterType.connection_type, null: false, method: :node_parameters,
                                                                 description: 'The parameters of the Node Function'
    field :runtime_function, Types::RuntimeFunctionDefinitionType, null: false,
                                                                   description: 'The definition of the Node Function'

    id_field NodeFunction
    timestamps
  end
end
