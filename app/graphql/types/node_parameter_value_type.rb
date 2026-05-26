# frozen_string_literal: true

module Types
  class NodeParameterValueType < Types::BaseUnion
    description 'Represents a parameter value for a node.'

    possible_types Types::SubFlowValueType, Types::LiteralValueType, Types::ReferenceValueType,
                   description: 'The value can be a literal, a reference, or a sub-flow.'

    def self.resolve_type(object, _context)
      case object
      when ReferenceValue
        Types::ReferenceValueType
      when SubFlow
        Types::SubFlowValueType
      else
        Types::LiteralValueType
      end
    end
  end
end
