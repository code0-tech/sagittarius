# frozen_string_literal: true

module Types
  class TimeType < BaseScalar
    description <<~DESC
      Time represented in ISO 8601.

      For example: "2023-12-15T17:31:00Z".
    DESC

    def self.coerce_input(value, _ctx)
      return if value.nil?

      time = Time.zone.parse(value)
      raise GraphQL::CoercionError, "Can not coerce #{value} to a time" if time.nil?

      time
    rescue ArgumentError, TypeError => e
      raise GraphQL::CoercionError, e.message
    end

    def self.coerce_result(value, _ctx)
      value.iso8601
    end
  end
end
