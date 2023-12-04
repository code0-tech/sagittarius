# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def self.inherited(subclass)
      subclass.graphql_name subclass.name.delete_prefix('Mutations::').gsub('::', '')
    end

    field :errors, [GraphQL::Types::String],
          null: false,
          description: 'Errors encountered during execution of the mutation.'
  end
end
