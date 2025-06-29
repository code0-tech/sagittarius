# frozen_string_literal: true

module Types
  class DataTypeIdentifierType < Types::BaseObject
    description 'Represents a data type identifier.'

    field :data_type, Types::DataTypeType, null: true, description: 'The data type of the data type identifier.'

    # rubocop:disable GraphQL/ExtractType -- generic_key and generic_type don't have anything in common
    field :generic_key, String, null: true, description: 'The generic key of the data type identifier.'
    field :generic_type, Types::GenericTypeType, null: true,
                                                 description: 'The generic type of the data type identifier.'
    # rubocop:enable GraphQL/ExtractType

    id_field DataTypeIdentifier
    timestamps
  end
end
