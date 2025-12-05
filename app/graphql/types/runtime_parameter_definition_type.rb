# frozen_string_literal: true

module Types
  class RuntimeParameterDefinitionType < Types::BaseObject
    description 'Represents a runtime parameter definition'

    authorize :read_runtime_parameter_definition

    field :identifier, String,
          null: false,
          description: 'Identifier of the runtime parameter definition',
          method: :runtime_name

    id_field RuntimeParameterDefinition
    timestamps
  end
end
