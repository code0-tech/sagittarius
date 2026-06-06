# frozen_string_literal: true

module Types
  class BigIntType < Types::BaseScalar
    description 'Represents non-fractional signed whole numeric values outside the range of a 32-bit integer.'

    def self.coerce_input(value, _ctx)
      Integer(value)
    rescue ArgumentError, TypeError => e
      raise GraphQL::CoercionError, e.message
    end

    def self.coerce_result(value, _ctx)
      Integer(value)
    rescue ArgumentError, TypeError => e
      raise GraphQL::CoercionError, e.message
    end
  end
end
