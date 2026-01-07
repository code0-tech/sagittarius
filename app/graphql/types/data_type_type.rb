# frozen_string_literal: true

module Types
  class DataTypeType < Types::BaseObject
    description 'Represents a DataType'

    authorize :read_datatype

    field :aliases, [Types::TranslationType], null: true, description: 'Name of the function'
    field :display_messages, [Types::TranslationType], null: true,
                                                       description: 'Display message of the function'
    field :generic_keys, [String], null: true, description: 'Generic keys of the datatype'
    field :identifier, String, null: false, description: 'The identifier scoped to the namespace'
    field :name, [Types::TranslationType], method: :names, null: false,
                                           description: 'Names of the flow type setting'
    field :rules, Types::DataTypeRuleType.connection_type, null: false,
                                                           description: 'Rules of the datatype'
    field :runtime, Types::RuntimeType, null: true,
                                        description: 'The runtime where this datatype belongs to'
    field :variant, Types::DataTypeVariantEnum, null: false,
                                                description: 'The type of the datatype'

    field :data_type_identifiers, Types::DataTypeIdentifierType.connection_type,
          null: false,
          description: 'The data type identifiers that are referenced in this data type and its rules'

    id_field DataType
    timestamps
  end
end
