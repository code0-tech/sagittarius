# frozen_string_literal: true

module Types
  module DataTypeRules
    class InputTypesConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      authorize :read_datatype

      field :input_types, [Types::DataTypeRules::InputTypeConfigType],
            null: false, description: 'The input types that can be used in this data type rule'
    end
  end
end
