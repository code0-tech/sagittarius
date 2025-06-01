# frozen_string_literal: true

module Types
  class RuntimeFunctionDefinitionType < Types::BaseObject
    description 'Represents a Node Function definition'

    authorize :read_flow

    id_field RuntimeParameterDefinition
    timestamps
  end
end
