# frozen_string_literal: true

module Types
  module Errors
    # rubocop:disable GraphQL/GraphqlName -- we don't want the module prefix
    class FlowValidationErrorType < Types::BaseObject
      graphql_name 'FlowValidationError'
      # rubocop:enable GraphQL/GraphqlName
      description 'Represents an flow validation error'

      field :details, Errors::ActiveModelErrorType, null: true,
                                                    description: 'Additional details about the validation error'
      field :error_code, Errors::FlowValidationErrorCodeEnum,
            null: false, description: 'The code representing the validation error type'
      field :severity, Errors::FlowValidationSeverityEnum, null: false,
                                                           description: 'The severity of the validation error'
    end
  end
end
