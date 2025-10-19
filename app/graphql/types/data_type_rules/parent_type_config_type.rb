# frozen_string_literal: true

module Types
  module DataTypeRules
    class ParentTypeConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      field :data_type_identifier, Types::DataTypeIdentifierType,
            null: false, description: 'The data type identifier for the parent type.'

      def data_type_identifier
        object.data_type.parent_type
      end
    end
  end
end
