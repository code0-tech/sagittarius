# frozen_string_literal: true

module Types
  class BaseInputObject < GraphQL::Schema::InputObject
    argument_class Types::BaseArgument

    def self.require_one_of(arguments)
      validates required: { one_of: arguments, message: "Only one of #{arguments.inspect} should be provided" }
    end
  end
end
