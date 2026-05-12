# frozen_string_literal: true

module Types
  class DateType < BaseScalar
    description <<~DESC
      Date represented in ISO 8601.

      For example: "2026-05-12".
    DESC

    def self.coerce_input(value, _ctx)
      return if value.nil?

      Date.iso8601(value)
    rescue ArgumentError, TypeError => e
      raise GraphQL::CoercionError, e.message
    end

    def self.coerce_result(value, _ctx)
      value.iso8601
    end
  end
end
