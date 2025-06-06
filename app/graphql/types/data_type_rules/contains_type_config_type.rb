# frozen_string_literal: true

module Types
  module DataTypeRules
    class ContainsTypeConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      authorize :read_flow

      field :data_type_identifier, Types::DataTypeIdentifierType,
            null: false, description: 'The identifier of the data type this rule belongs to'
    end
  end
end
