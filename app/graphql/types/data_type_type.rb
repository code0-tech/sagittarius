# frozen_string_literal: true

module Types
  class DataTypeType < Types::BaseObject
    description 'Represents a DataType'

    authorize :read_datatype

    field :identifier, String, null: false, description: 'The identifier scoped to the namespace'
    field :namespace, Types::NamespaceType, null: true,
                                            description: 'The namespace where this datatype belongs to'
    field :variant, Types::DataTypeVariantEnum, null: false, description: 'The type of the datatype'

    id_field DataType
    timestamps
  end
end
