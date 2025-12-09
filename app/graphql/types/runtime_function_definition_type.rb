# frozen_string_literal: true

module Types
  class RuntimeFunctionDefinitionType < Types::BaseObject
    description 'Represents a runtime function definition'

    authorize :read_runtime_function_definition

    field :runtime, Types::RuntimeType,
          null: false, description: 'The runtime this runtime function definition belongs to'

    field :function_definitions, Types::FunctionDefinitionType.connection_type,
          null: true,
          description: 'Function definitions of the runtime function definition'

    field :runtime_parameter_definitions, Types::RuntimeParameterDefinitionType.connection_type,
          null: true,
          description: 'Parameter definitions of the runtime function definition'

    field :identifier, String,
          null: false,
          description: 'Identifier of the runtime function definition',
          method: :runtime_name

    id_field RuntimeFunctionDefinition
    timestamps
  end
end
