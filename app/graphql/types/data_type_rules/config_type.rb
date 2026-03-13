# frozen_string_literal: true

module Types
  module DataTypeRules
    class ConfigType < Types::BaseUnion
      description 'Represents a rule that can be applied to a data type.'

      possible_types NumberRangeConfigType, RegexConfigType

      def self.resolve_type(object, _context)
        case object[:variant].to_sym
        when :number_range
          Types::DataTypeRules::NumberRangeConfigType
        when :regex
          Types::DataTypeRules::RegexConfigType
        else
          raise GraphQL::ExecutionError, "Unknown data type rule variant: #{object[:variant]}"
        end
      end
    end
  end
end
