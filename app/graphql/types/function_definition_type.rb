# frozen_string_literal: true

module Types
  class FunctionDefinitionType < Types::BaseObject
    description 'Represents a function definition'

    authorize :read_function_definition

    field :identifier, String, null: false,
                               description: 'Identifier of the function',
                               method: :runtime_name

    field :parameter_definitions, Types::ParameterDefinitionType.connection_type,
          null: true,
          description: 'Parameters of the function'

    field :aliases, [Types::TranslationType], null: true, description: 'Name of the function'
    field :descriptions, [Types::TranslationType], null: true, description: 'Description of the function'
    field :display_messages, [Types::TranslationType], null: true,
                                                       description: 'Display message of the function'
    field :names, [Types::TranslationType], null: true, description: 'Name of the function'

    field :deprecation_messages, [Types::TranslationType],
          null: true,
          description: 'Deprecation message of the function'
    field :documentations, [Types::TranslationType],
          null: true,
          description: 'Documentation of the function'

    field :runtime_function_definition, Types::RuntimeFunctionDefinitionType,
          null: true, description: 'Runtime function definition'

    field :signature, String, null: false, description: 'Signature of the function'

    field :throws_error, Boolean,
          null: false, description: 'Indicates if the function can throw an error'

    field :version, String,
          null: false,
          description: 'Version of the runtime function definition'

    field :definition_source, String,
          null: true,
          description: 'The source that defines this definition'

    # rubocop:disable GraphQL/ExtractType
    field :display_icon, String,
          null: true, description: 'Display icon of the function'
    # rubocop:enable GraphQL/ExtractType

    field :linked_data_types, Types::DataTypeType.connection_type,
          null: false,
          description: 'All data types referenced within this function definition'

    id_field FunctionDefinition
    timestamps

    def linked_data_types
      DataTypesFinder.new({ function_definition: object, expand_recursively: true }).execute
    end
  end
end
