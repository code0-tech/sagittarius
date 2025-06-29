# frozen_string_literal: true

module Types
  module DataTypeRules
    class ConfigType < Types::BaseUnion
      description 'Represents a rule that can be applied to a data type.'

      possible_types ContainsKeyConfigType, ContainsTypeConfigType, NumberRangeConfigType, ItemOfCollectionConfigType,
                     RegexConfigType

      def self.resolve_type(object, _context)
        case object[:variant]
        when :contains_key
          Types::DataTypeRuleContainsKeyType
        when :contains_type
          Types::DataTypeRuleContainsTypeType
        when :number_range
          Types::DataTypeRuleNumberRangeType
        when :item_of_collection
          Types::DataTypeRuleItemOfCollectionType
        when :regex
          Types::DataTypeRuleRegexType
        else
          raise GraphQL::ExecutionError, "Unknown data type rule variant: #{object.variant}"
        end
      end
    end
  end
end
