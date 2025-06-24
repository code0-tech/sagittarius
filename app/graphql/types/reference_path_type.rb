# frozen_string_literal: true

module Types
  class ReferencePathType < Types::BaseObject
    description 'Represents a reference path in a flow'

    authorize :read_flow

    field :array_index, Integer, null: true, description: 'The array index of the referenced data by the path'
    field :path, String, null: true, description: 'The path to the reference in the flow'

    id_field ReferencePath
    timestamps
  end
end
