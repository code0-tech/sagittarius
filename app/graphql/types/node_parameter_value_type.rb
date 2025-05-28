# frozen_string_literal: true

module Types
  class NodeParameterValueType < Types::BaseUnion
    description 'Represents a parameter value for a node.'

    possible_types Types::LiteralValueType, Types::ReferenceValueType, Types::NodeFunctionType,
                   description: 'The value can be a literal, a reference, or a node function.'

    def self.resolve_type(object, _context)
      case object
      when LiteralValue
        Types::LiteralValueType
      when ReferenceValue
        Types::ReferenceValueType
      when NodeFunction
        Types::NodeFunctionType
      else
        raise "Unexpected value type: #{object.class}"
      end
    end
  end
end
