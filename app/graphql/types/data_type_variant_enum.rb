# frozen_string_literal: true

module Types
  class DataTypeVariantEnum < BaseEnum
    description 'Represent all available types of a datatype'

    value :PRIMITIVE, 'Represents a primitive datatype like string, int, ...', value: :primitive
    value :TYPE, 'Represents a type', value: :type
    value :OBJECT, 'Represents an object', value: :object
    value :DATA_TYPE, 'Represents an other data type as the variant', value: :datatype
    value :ARRAY, 'Represents a list', value: :array
  end
end
