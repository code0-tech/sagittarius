# frozen_string_literal: true

module Types
  module DataTypeRules
    class VariantEnum < Types::BaseEnum
      description 'The type of rule that can be applied to a data type.'

      value :NUMBER_RANGE, 'The rule checks if a number falls within a specified range.',
            value: :number_range
      value :REGEX, 'The rule checks if a string matches a specified regular expression.',
            value: :regex
    end
  end
end
