# frozen_string_literal: true

module Types
  module Errors
    # rubocop:disable GraphQL/GraphqlName -- we don't want the module prefix
    class DetailedErrorType < Types::BaseUnion
      graphql_name 'DetailedError'
      # rubocop:enable GraphQL/GraphqlName
      description 'Represents a detailed error with either a message or an active model error'
      possible_types Types::Errors::ActiveModelErrorType, Types::Errors::MessageErrorType,
                     Types::Errors::FlowValidationErrorType

      def self.resolve_type(object, _ctx)
        case object
        when Namespaces::Projects::Flows::Validation::ValidationResult
          Types::Errors::FlowValidationErrorType
        when ActiveModel::Error
          Types::Errors::ActiveModelErrorType
        when Hash
          Types::Errors::MessageErrorType
        else
          raise 'Unsupported DetailedErrorType'
        end
      end
    end
  end
end
