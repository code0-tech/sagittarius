# frozen_string_literal: true

module Types
  class FunctionDefinitionType < Types::BaseObject
    description 'Represents a function definition'

    authorize :read_function_definition

    field :return_type, Types::DataTypeIdentifierType, null: true, description: 'Return type of the function'

    field :parameter_definitions, Types::ParameterDefinitionType.connection_type,
          null: true,
          description: 'Parameters of the function'

    field :descriptions, Types::TranslationType.connection_type, null: true, description: 'Description of the function'
    field :names, Types::TranslationType.connection_type, null: true, description: 'Name of the function'

    field :documentations, Types::TranslationType.connection_type,
          null: true,
          description: 'Documentation of the function'

    id_field FunctionDefinition
    timestamps
  end
end
