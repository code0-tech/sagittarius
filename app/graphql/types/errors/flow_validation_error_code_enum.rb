# frozen_string_literal: true

module Types
  module Errors
    # rubocop:disable GraphQL/GraphqlName -- we don't want the module prefix
    class FlowValidationErrorCodeEnum < Types::BaseEnum
      graphql_name 'FlowValidationErrorCodeEnum'
      # rubocop:enable GraphQL/GraphqlName
      description 'Represents the available error responses'

      ::Namespaces::Projects::Flows::Validation::FlowValidationErrorCode.error_codes.each do |error_code, details|
        value error_code.upcase, details[:description],
              value: error_code,
              deprecation_reason: details.fetch(:deprecation_reason, nil)
      end
    end
  end
end
