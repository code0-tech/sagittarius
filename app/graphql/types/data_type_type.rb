# frozen_string_literal: true

module Types
  class DataTypeType < Types::BaseObject
    description 'Represents a DataType'

    authorize :read_datatype

    field :generic_keys, [String], null: true, description: 'Generic keys of the datatype'
    field :identifier, String, null: false, description: 'The identifier scoped to the namespace'
    field :name, Types::TranslationType.connection_type, method: :names, null: false,
                                                         description: 'Names of the flow type setting'
    field :namespace, Types::NamespaceType, null: true,
                                            description: 'The namespace where this datatype belongs to'
    field :parent, Types::DataTypeIdentifierType,
          null: true, description: 'The parent datatype'
    field :rules, Types::DataTypeRuleType.connection_type, null: false,
                                                           description: 'Rules of the datatype'
    field :variant, Types::DataTypeVariantEnum, null: false,
                                                description: 'The type of the datatype'

    id_field DataType
    timestamps
  end
end
