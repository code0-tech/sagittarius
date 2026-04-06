# frozen_string_literal: true

module Types
  class RuntimeParameterDefinitionType < Types::BaseObject
    description 'Represents a runtime parameter definition'

    authorize :read_runtime_parameter_definition

    field :identifier, String,
          null: false,
          description: 'Identifier of the runtime parameter definition',
          method: :runtime_name

    field :default_value, GraphQL::Types::JSON,
          null: true,
          description: 'Default value of the runtime parameter definition'

    field :descriptions, [Types::TranslationType], null: true,
                                                   description: 'Descriptions of the runtime parameter definition'
    field :documentations, [Types::TranslationType], null: true,
                                                     description: 'Documentations of the runtime parameter definition'
    field :names, [Types::TranslationType], null: true, description: 'Names of the runtime parameter definition'

    id_field RuntimeParameterDefinition
    timestamps
  end
end
