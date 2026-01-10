# frozen_string_literal: true

module Types
  module DataTypeRules
    class ParentTypeConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      # rubocop:disable GraphQL/ExtractType -- one of the fields is types-only
      field :data_type_identifier, Types::DataTypeIdentifierType,
            null: false,
            description: 'types-only field',
            visibility_profile: :types

      field :data_type_identifier_id, Types::GlobalIdType[::DataTypeIdentifier],
            null: false, description: 'ID of the data type identifier for the parent type.'
      # rubocop:enable GraphQL/ExtractType

      def data_type_identifier_id
        object.data_type.parent_type.to_global_id
      end
    end
  end
end
