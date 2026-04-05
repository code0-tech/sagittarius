# frozen_string_literal: true

module Types
  class FunctionDefinitionType < Types::BaseObject
    description 'Represents a function definition'

    authorize :read_function_definition

    field :identifier, String, null: false, description: 'Identifier of the function'

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

    # rubocop:disable GraphQL/ExtractType
    field :display_icon, String,
          null: true, description: 'Display icon of the function'
    # rubocop:enable GraphQL/ExtractType

    field :linked_data_types, Types::DataTypeType.connection_type,
          null: false,
          description: 'All data types referenced within this function definition'

    id_field FunctionDefinition
    timestamps

    def identifier
      object.runtime_function_definition&.runtime_name
    end

    def signature
      object.runtime_function_definition&.signature
    end

    def throws_error
      object.runtime_function_definition&.throws_error
    end

    def display_icon
      object.runtime_function_definition&.display_icon
    end

    def linked_data_types
      return [] unless object.runtime_function_definition

      DataTypesFinder.new({ runtime_function_definition: object.runtime_function_definition,
                            expand_recursively: true }).execute
    end
  end
end
