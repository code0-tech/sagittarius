# frozen_string_literal: true

module Types
  class NodeParameterValueType < Types::BaseUnion
    description 'Represents a parameter value for a node.'

    possible_types Types::LiteralValueType, Types::ReferenceValueType, Types::NodeFunctionIdType,
                   description: 'The value can be a literal, a reference, or a node function id.'

    def self.resolve_type(object, _context)
      case object
      when ReferenceValue
        Types::ReferenceValueType
      when NodeFunction
        Types::NodeFunctionIdType
      else
        Types::LiteralValueType
      end
    end
  end
end
