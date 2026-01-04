# frozen_string_literal: true

module Types
  class FunctionDefinitionType < Types::BaseObject
    description 'Represents a function definition'

    authorize :read_function_definition

    field :identifier, String, null: false, description: 'Identifier of the function'

    field :return_type, Types::DataTypeIdentifierType, null: true, description: 'Return type of the function'

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

    field :generic_keys, [String], null: true, description: 'Generic keys of the function'

    field :throws_error, Boolean,
          null: false, description: 'Indicates if the function can throw an error'

    field :data_type_identifiers, Types::DataTypeIdentifierType.connection_type,
          null: false,
          description: 'All data type identifiers used within this Node Function'

    id_field FunctionDefinition
    timestamps

    def identifier
      object.runtime_function_definition&.runtime_name
    end

    def data_type_identifiers
      DataTypeIdentifiersFinder.new({ function_definition: object, expand_recursively: true }).execute
    end
  end
end
