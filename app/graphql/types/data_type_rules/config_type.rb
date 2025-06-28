# frozen_string_literal: true

module Types
  module DataTypeRules
    class ConfigType < Types::BaseUnion
      description 'Represents a rule that can be applied to a data type.'

      possible_types ContainsKeyConfigType, ContainsTypeConfigType, NumberRangeConfigType, ItemOfCollectionConfigType,
                     RegexConfigType, InputTypesConfigType, ReturnTypeConfigType

      def self.resolve_type(object, _context)
        case object[:variant]
        when :contains_key
          Types::DataTypeRules::ContainsKeyConfigType
        when :contains_type
          Types::DataTypeRules::ContainsTypeConfigType
        when :number_range
          Types::DataTypeRules::NumberRangeConfigType
        when :item_of_collection
          Types::DataTypeRules::ItemOfCollectionConfigType
        when :regex
          Types::DataTypeRules::RegexConfigType
        when :input_types
          Types::DataTypeRules::InputTypesConfigType
        when :return_type
          Types::DataTypeRules::ReturnTypeConfigType
        else
          raise GraphQL::ExecutionError, "Unknown data type rule variant: #{object[:variant]}"
        end
      end
    end
  end
end
