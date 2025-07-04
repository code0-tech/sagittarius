# frozen_string_literal: true

module Types
  class GenericMapperType < Types::BaseObject
    description 'Represents a mapping between a source data type and a target key for generic values.'

    authorize :read_datatype

    field :source, Types::DataTypeIdentifierType, null: false, description: 'The source data type identifier.'
    field :target, String, null: false, description: 'The target key for the generic value.'

    id_field GenericMapper
    timestamps
  end
end
