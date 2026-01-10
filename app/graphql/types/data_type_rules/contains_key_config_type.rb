# frozen_string_literal: true

module Types
  module DataTypeRules
    class ContainsKeyConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      # rubocop:disable GraphQL/ExtractType -- one of the fields is types-only
      field :data_type_identifier, Types::DataTypeIdentifierType,
            null: false,
            description: 'types-only field',
            visibility_profile: :types

      field :data_type_identifier_id, Types::GlobalIdType[::DataTypeIdentifier],
            null: false, description: 'ID of the identifier of the data type this rule belongs to'
      # rubocop:enable GraphQL/ExtractType

      field :key, String, null: false, description: 'The key of the rule'

      def data_type_identifier_id
        DataTypeIdentifier.new(id: object['data_type_identifier_id']).to_global_id
      end
    end
  end
end
