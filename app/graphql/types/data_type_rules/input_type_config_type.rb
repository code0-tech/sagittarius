# frozen_string_literal: true

module Types
  module DataTypeRules
    class InputTypeConfigType < Types::BaseObject
      description 'Represents a subtype of input type configuration for a input data type.'

      authorize :read_datatype

      field :data_type_identifier, Types::DataTypeIdentifierType,
            null: false, description: 'The identifier of the data type this input type belongs to'

      field :input_type, Types::DataTypeType,
            null: false, description: 'The input data type that this configuration applies to'
    end
  end
end
