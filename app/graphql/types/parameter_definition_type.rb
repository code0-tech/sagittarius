# frozen_string_literal: true

module Types
  class ParameterDefinitionType < Types::BaseObject
    description 'Represents a parameter definition'

    authorize :read_parameter_definition

    field :data_type, Types::DataTypeIdentifierType, null: true, description: 'Data type of the parameter'

    field :descriptions, Types::TranslationType.connection_type, null: true, description: 'Description of the parameter'
    field :names, Types::TranslationType.connection_type, null: true, description: 'Name of the parameter'

    field :documentations, Types::TranslationType.connection_type,
          null: true,
          description: 'Documentation of the parameter'

    id_field ParameterDefinition
    timestamps
  end
end
