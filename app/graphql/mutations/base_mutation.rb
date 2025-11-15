# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    include Sagittarius::Graphql::HasMarkdownDocumentation

    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def self.inherited(subclass)
      super
      subclass.graphql_name subclass.name.delete_prefix('Mutations::').gsub('::', '')
    end

    def self.require_one_of(arguments)
      validates required: { one_of: arguments, message: "Only one of #{arguments.inspect} should be provided" }
    end

    field :errors, [Types::Errors::ErrorType],
          null: false,
          description: 'Errors encountered during execution of the mutation.'

    def current_authentication
      context[:current_authentication]
    end

    def create_error(code, message)
      ErrorCode.validate_error_code!(code)

      Sagittarius::Graphql::ErrorContainer.new(
        code,
        [{ message: message }]
      )
    end
  end
end
