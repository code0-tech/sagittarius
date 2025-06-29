# frozen_string_literal: true

module Types
  module DataTypeRules
    class DataTypeRuleVariantEnum < Types::BaseEnum
      description 'The type of rule that can be applied to a data type.'

      value :CONTAINS_KEY, 'The rule checks if a key is present in the data type.',
            value: :contains_key
      value :CONTAINS_TYPE, 'The rule checks if a specific type is present in the data type.',
            value: :contains_type
      value :NUMBER_RANGE, 'The rule checks if a number falls within a specified range.',
            value: :number_range
      value :ITEM_OF_COLLECTION, 'The rule checks if an item is part of a collection in the data type.',
            value: :item_of_collection
      value :REGEX, 'The rule checks if a string matches a specified regular expression.',
            value: :regex
      value :INPUT_TYPE, 'The rule checks if the data type matches a specific input type.',
            value: :input_type
      value :RETURN_TYPE, 'The rule checks if the data type matches a specific return type.',
            value: :return_type
    end
  end
end
