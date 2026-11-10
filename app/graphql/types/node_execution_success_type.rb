# frozen_string_literal: true

module Types
  class NodeExecutionSuccessType < Types::BaseUnion
    description 'A successful node execution value: either a raw JSON value or a sub-flow function result.'

    possible_types Types::RawValueType, Types::SubFlowFunctionResultType

    def self.resolve_type(object, _context)
      case object
      when Sagittarius::Graphql::RawValue
        Types::RawValueType
      else
        Types::SubFlowFunctionResultType
      end
    end
  end
end
