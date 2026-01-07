# frozen_string_literal: true

module Types
  module DataTypeRules
    class ReturnTypeConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      field :data_type_identifier_id, Types::GlobalIdType[::DataTypeIdentifier],
            null: false, description: 'The data type identifier for the return type.'
    end
  end
end
