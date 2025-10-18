# frozen_string_literal: true

module Types
  class RuntimeFunctionDefinitionType < Types::BaseObject
    description 'Represents a Node Function definition'

    authorize :read_flow

    field :runtime, Types::RuntimeType,
          null: false, description: 'The runtime this Node Function belongs to'

    field :function_definitions, Types::FunctionDefinitionType.connection_type,
          null: true,
          description: 'Function definitions of the Node Function'

    field :identifier, String, null: false, description: 'Identifier of the Node Function', method: :runtime_name

    id_field RuntimeParameterDefinition
    timestamps
  end
end
