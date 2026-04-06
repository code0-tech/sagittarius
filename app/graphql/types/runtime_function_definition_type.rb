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

    field :throws_error, Boolean,
          null: false,
          description: 'Indicates if the function can throw an error'

    field :display_icon, String,
          null: true,
          description: 'Display icon of the runtime function definition'

    field :version, String,
          null: false,
          description: 'Version of the runtime function definition'

    field :definition_source, String,
          null: true,
          description: 'The source that defines this definition'

    field :aliases, [Types::TranslationType], null: true, description: 'Aliases'
    field :deprecation_messages, [Types::TranslationType], null: true,
                                                           description: 'Deprecation messages'
    field :descriptions, [Types::TranslationType], null: true,
                                                   description: 'Descriptions of the runtime function definition'
    # rubocop:disable GraphQL/ExtractType
    field :display_messages, [Types::TranslationType], null: true, description: 'Display messages'
    # rubocop:enable GraphQL/ExtractType
    field :documentations, [Types::TranslationType], null: true,
                                                     description: 'Documentations of the runtime function definition'
    field :names, [Types::TranslationType], null: true, description: 'Names of the runtime function definition'

    field :linked_data_types, Types::DataTypeType.connection_type,
          null: false,
          description: 'The data types that are referenced in this runtime function definition'

    id_field RuntimeFunctionDefinition
    timestamps

    def linked_data_types
      DataTypesFinder.new({ runtime_function_definition: object, expand_recursively: true }).execute
    end
  end
end
