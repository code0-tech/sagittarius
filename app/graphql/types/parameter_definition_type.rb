# frozen_string_literal: true

module Types
  class ParameterDefinitionType < Types::BaseObject
    description 'Represents a parameter definition'

    authorize :read_parameter_definition

    field :identifier, String, null: false, description: 'Identifier of the parameter'

    field :data_type_identifier, Types::DataTypeIdentifierType,
          null: true,
          description: 'Data type of the parameter',
          method: :data_type

    field :descriptions, [Types::TranslationType], null: true, description: 'Description of the parameter'
    field :names, [Types::TranslationType], null: true, description: 'Name of the parameter'

    field :documentations, [Types::TranslationType],
          null: true,
          description: 'Documentation of the parameter'

    id_field ParameterDefinition
    timestamps

    def identifier
      object.runtime_parameter_definition&.runtime_name
    end
  end
end
