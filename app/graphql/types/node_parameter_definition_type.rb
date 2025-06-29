# frozen_string_literal: true

module Types
  class NodeParameterDefinitionType < Types::BaseObject
    description 'Represents a Node parameter definition'

    authorize :read_flow

    field :parameter_id, String, null: false, description: 'The ID of the parameter'
    field :runtime_parameter_id, String, null: false, description: 'The runtime ID of the parameter'

    timestamps
  end
end
