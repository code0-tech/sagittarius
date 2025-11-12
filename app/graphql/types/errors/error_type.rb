# frozen_string_literal: true

module Types
  module Errors
    # rubocop:disable GraphQL/GraphqlName -- we don't want the module prefix
    class ErrorType < Types::BaseObject
      graphql_name 'Error'
      # rubocop:enable GraphQL/GraphqlName
      description 'Objects that can present an error'

      field :code, Errors::ErrorCodeType, null: false, description: 'The code representing the error type'
      field :details, [Errors::DetailedErrorType], null: true, description: 'Detailed validation errors if applicable'
    end
  end
end
