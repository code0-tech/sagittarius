# frozen_string_literal: true

module Types
  module DataTypeRules
    class InputTypeConfigType < Types::BaseObject
      description 'Represents a subtype of input type configuration for a input data type.'

      # rubocop:disable GraphQL/ExtractType -- one of the fields is types-only
      field :data_type_identifier, Types::DataTypeIdentifierType,
            null: false,
            description: 'types-only field',
            visibility_profile: :types

      field :data_type_identifier_id, Types::GlobalIdType[::DataTypeIdentifier],
            null: false, description: 'ID of the identifier of the data type this input type belongs to'
      # rubocop:enable GraphQL/ExtractType

      field :input_identifier, String,
            null: false, description: 'The input identifier that this configuration applies to'

      def data_type_identifier_id
        DataTypeIdentifier.new(id: object['data_type_identifier_id']).to_global_id
      end
    end
  end
end
