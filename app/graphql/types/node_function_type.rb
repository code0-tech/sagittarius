# frozen_string_literal: true

module Types
  class NodeFunctionType < Types::BaseObject
    description 'Represents a Node Function'

    authorize :read_flow

    field :function, Types::NodeFunctionDefinitionType, null: false, description: 'The definition of the Node Function'
    field :next_node, Types::NodeFunctionType, null: true, description: 'The next Node Function in the flow'
    field :parameters, Types::NodeParameterType.connection_type, null: false, method: :node_parameters,
                                                                 description: 'The parameters of the Node Function'

    def function
      {
        function_id: '',
        runtime_function_id: object.runtime_function.runtime_name,
      }
    end

    id_field NodeFunction
    timestamps
  end
end
