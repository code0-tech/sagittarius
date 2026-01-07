# frozen_string_literal: true

module Types
  module DataTypeRules
    class ContainsTypeConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      field :data_type_identifier_id, Types::GlobalIdType[::DataTypeIdentifier],
            null: false, description: 'ID of the identifier of the data type this rule belongs to'
    end
  end
end
