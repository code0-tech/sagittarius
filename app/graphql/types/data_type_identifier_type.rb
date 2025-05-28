# frozen_string_literal: true

module Types
  class DataTypeIdentifierType < Types::BaseUnion
    description 'Represents a data type identifier.'

    possible_types Types::GenericTypeType, Types::DataTypeType, Types::GenericKeyType,
                   description: 'The identifier can be a generic type, a data type, or a generic key.'

    def self.resolve_type(object, _context)
      case object
      when GenericType
        Types::GenericTypeType
      when DataType
        Types::DataTypeType
      when GenericKey
        Types::GenericKeyType
      else
        raise "Unexpected value type: #{object.class}"
      end
    end
  end
end
