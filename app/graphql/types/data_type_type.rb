# frozen_string_literal: true

module Types
  class DataTypeType < Types::BaseObject
    description 'Represents a DataType'

    authorize :read_datatype

    field :aliases, [Types::TranslationType], null: true, description: 'Name of the function'
    field :definition_source, String, null: true, description: 'The source that defines this datatype'
    field :display_messages, [Types::TranslationType], null: true,
                                                       description: 'Display message of the function'
    field :generic_keys, [String], null: false, description: 'The generic keys of the datatype'
    field :identifier, String, null: false, description: 'The identifier scoped to the namespace'
    field :name, [Types::TranslationType], method: :names, null: false,
                                           description: 'Names of the flow type setting'
    field :rules, Types::DataTypeRuleType.connection_type, null: false,
                                                           description: 'Rules of the datatype'
    field :runtime, Types::RuntimeType, null: true,
                                        description: 'The runtime where this datatype belongs to'
    field :type, String, null: false, description: 'The type of the datatype'
    field :version, String, null: false, description: 'The version of the datatype'

    field :linked_data_types, Types::DataTypeType.connection_type,
          null: false,
          description: 'The data types that are referenced in this data type'

    id_field DataType
    timestamps

    def linked_data_types
      DataTypesFinder.new({ data_type: object, expand_recursively: true }).execute
    end
  end
end
