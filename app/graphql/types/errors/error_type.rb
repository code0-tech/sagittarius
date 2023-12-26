# frozen_string_literal: true

module Types
  module Errors
    class ErrorType < BaseUnion
      description 'Objects that can present an error'
      possible_types Errors::ActiveModelErrorType, Errors::MessageErrorType

      def self.resolve_type(object, _ctx)
        case object
        when ActiveModel::Error
          Errors::ActiveModelErrorType
        when Sagittarius::Graphql::ErrorMessageContainer
          Errors::MessageErrorType
        else
          raise 'Unsupported ErrorType'
        end
      end
    end
  end
end
