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

    field :signature, String,
          null: false,
          description: 'Signature of the runtime function definition'

    field :referenced_data_types, Types::DataTypeType.connection_type,
          null: false,
          description: 'The data types that are referenced in this runtime function definition'

    id_field RuntimeFunctionDefinition
    timestamps

    def referenced_data_types
      DataTypesFinder.new({ runtime_function_definition: object, expand_recursively: true }).execute
    end
  end
end
