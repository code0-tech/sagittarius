# frozen_string_literal: true

module Types
  class RuntimeParameterDefinitionType < Types::BaseObject
    description 'Represents a Node parameter definition'

    authorize :read_flow

    id_field RuntimeParameterDefinition
    timestamps
  end
end
