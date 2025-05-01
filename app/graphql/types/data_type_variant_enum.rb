# frozen_string_literal: true

module Types
  class DataTypeVariantEnum < BaseEnum
    description 'Represent all available types of a datatype'

    value :PRIMITIVE, 'Represents a primitive datatype', value: :primitive
    value :TYPE, 'Represents a type', value: :type
    value :OBJECT, 'Represents an object', value: :object
    value :DATA_TYPE, 'Represents an data type containing a data type', value: :datatype
    value :ARRAY, 'Represents an array', value: :array
    value :GENERIC, 'Represents a generic', value: :generic
    value :FUNCTION, 'Represents a function', value: :function
  end
end
