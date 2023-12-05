# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def self.inherited(subclass)
      super
      subclass.graphql_name subclass.name.delete_prefix('Mutations::').gsub('::', '')
    end

    def self.require_one_of(arguments, context)
      context.instance_eval do
        validates required: { one_of: arguments, message: "Only one of #{arguments.inspect} should be provided" }
      end
    end

    field :errors, [GraphQL::Types::String],
          null: false,
          description: 'Errors encountered during execution of the mutation.'
  end
end
