# frozen_string_literal: true

module Subscriptions
  module Velorum
    class GenerateFlow < BaseSubscription
      description 'Generate a flow through Velorum and close the subscription with the generated flow'

      argument :execution_identifier,
               type: GraphQL::Types::String,
               required: true,
               description: 'Velorum generation request identifier returned by the mutation'

      field :flow,
            type: GraphQL::Types::JSON,
            null: true,
            description: 'Generated flow returned by Velorum'

      def subscribe(**)
        :no_response
      end

      def update(*)
        unsubscribe(flow: object)
      end
    end
  end
end
