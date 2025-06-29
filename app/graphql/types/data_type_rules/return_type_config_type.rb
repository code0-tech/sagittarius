# frozen_string_literal: true

module Types
  module DataTypeRules
    class ReturnTypeConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      authorize :read_datatype

      field :data_type_identifier, Types::DataTypeIdentifierType,
            null: false, description: 'The data type identifier for the return type.'
    end
  end
end
