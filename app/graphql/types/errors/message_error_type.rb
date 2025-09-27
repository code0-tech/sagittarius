# frozen_string_literal: true

module Types
  module Errors
    # rubocop:disable GraphQL/GraphqlName -- we don't want the module prefix
    class MessageErrorType < Types::BaseObject
      graphql_name 'MessageError'
      # rubocop:enable GraphQL/GraphqlName
      description 'Represents an error message'

      field :message, String, null: false, description: 'The message provided from the error'
    end
  end
end
