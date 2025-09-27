# frozen_string_literal: true

module Types
  module Errors
    # rubocop:disable GraphQL/GraphqlName -- we don't want the module prefix
    class ActiveModelErrorType < Types::BaseObject
      graphql_name 'ActiveModelError'
      # rubocop:enable GraphQL/GraphqlName
      description 'Represents an active model error'

      field :attribute, String, null: false, description: 'The affected attribute on the model'
      field :type, String, null: false, description: 'The validation type that failed for the attribute'

      def type
        object.details[:error]
      end
    end
  end
end
