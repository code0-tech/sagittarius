# frozen_string_literal: true

module Types
  module Errors
    # rubocop:disable GraphQL/GraphqlName -- we don't want the module prefix
    class FlowValidationSeverityEnum < Types::BaseEnum
      graphql_name 'FlowValidationSeverityEnum'
      # rubocop:enable GraphQL/GraphqlName
      description 'Represents the severity of a flow validation error'

      value 'WARNING', 'A non-blocking validation warning', value: :warning
      value 'ERROR', 'A blocking validation error', value: :error
      value 'WEAK', 'A weak validation issue that may not need to be addressed', value: :weak
      value 'TYPO', 'A minor typographical issue can also be blocking', value: :typo
    end
  end
end
