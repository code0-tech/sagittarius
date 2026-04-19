# frozen_string_literal: true

module Types
  class ParameterDefinitionType < Types::BaseObject
    description 'Represents a parameter definition'

    authorize :read_parameter_definition

    field :identifier, String, null: false, description: 'Identifier of the parameter', method: :runtime_name

    field :descriptions, [Types::TranslationType], null: true, description: 'Description of the parameter'
    field :names, [Types::TranslationType], null: true, description: 'Name of the parameter'

    field :documentations, [Types::TranslationType],
          null: true,
          description: 'Documentation of the parameter'

    field :runtime_parameter_definition, Types::RuntimeParameterDefinitionType,
          null: true, description: 'Runtime parameter definition'

    field :default_value, GraphQL::Types::JSON,
          null: true, description: 'Default value of the parameter'

    id_field ParameterDefinition
    timestamps
  end
end
