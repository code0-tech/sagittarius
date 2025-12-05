# frozen_string_literal: true

module Types
  class NodeFunctionIdType < Types::BaseObject
    description 'Represents a Node Function id'

    authorize :read_flow
    id_field NodeFunction
  end
end
