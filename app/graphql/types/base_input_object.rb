# frozen_string_literal: true

module Types
  class BaseInputObject < GraphQL::Schema::InputObject
    argument_class Types::BaseArgument

    def self.inherited(subclass)
      super
      return if subclass.name.blank?

      subclass.graphql_name subclass.name.delete_prefix('Types::').gsub('::', '').delete_prefix('Input').delete_suffix('Type')
    end

    def self.require_one_of(arguments)
      validates required: { one_of: arguments, message: "Only one of #{arguments.inspect} should be provided" }
    end
  end
end
