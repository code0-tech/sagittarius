# frozen_string_literal: true

module Types
  module Errors
    # rubocop:disable GraphQL/GraphqlName -- we don't want the module prefix
    class ErrorCodeType < Types::BaseObject
      graphql_name 'ErrorCode'
      # rubocop:enable GraphQL/GraphqlName
      description 'Represents an error code'

      field :error_code, ErrorCodeEnum, null: false, description: 'The error code'
    end
  end
end
