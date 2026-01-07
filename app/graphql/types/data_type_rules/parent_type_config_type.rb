# frozen_string_literal: true

module Types
  module DataTypeRules
    class ParentTypeConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      field :data_type_identifier_id, Types::GlobalIdType[::DataTypeIdentifier],
            null: false, description: 'ID of the data type identifier for the parent type.'

      def data_type_identifier_id
        object.data_type.parent_type.to_global_id
      end
    end
  end
end
