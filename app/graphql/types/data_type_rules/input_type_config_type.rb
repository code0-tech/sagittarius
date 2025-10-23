# frozen_string_literal: true

module Types
  module DataTypeRules
    class InputTypeConfigType < Types::BaseObject
      description 'Represents a subtype of input type configuration for a input data type.'

      field :data_type_identifier, Types::DataTypeIdentifierType,
            null: false, description: 'The identifier of the data type this input type belongs to'

      field :input_identifier, String,
            null: false, description: 'The input identifier that this configuration applies to'
    end
  end
end
