# frozen_string_literal: true

module Types
  module Errors
    # rubocop:disable GraphQL/GraphqlName -- we don't want the module prefix
    class ErrorType < BaseUnion
      graphql_name 'Error'
      # rubocop:enable GraphQL/GraphqlName
      description 'Objects that can present an error'
      possible_types Errors::ActiveModelErrorType, Errors::MessageErrorType, Errors::ErrorCodeType

      def self.resolve_type(object, _ctx)
        case object
        when ActiveModel::Error
          Errors::ActiveModelErrorType
        when Sagittarius::Graphql::ErrorMessageContainer
          Errors::MessageErrorType
        when Sagittarius::Graphql::ServiceResponseErrorContainer
          Errors::ErrorCodeType
        else
          raise 'Unsupported ErrorType'
        end
      end
    end
  end
end
