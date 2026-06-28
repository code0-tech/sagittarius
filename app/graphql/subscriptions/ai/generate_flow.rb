# frozen_string_literal: true

module Subscriptions
  module Ai
    class GenerateFlow < BaseSubscription
      description 'Generate a flow through AI and close the subscription with the generated flow'

      argument :execution_identifier,
               type: GraphQL::Types::String,
               required: true,
               description: 'AI generation request identifier returned by the mutation'

      field :flow,
            type: Types::Ai::GenerationFlowType,
            null: true,
            description: 'Generated flow returned by AI'

      def subscribe(**)
        :no_response
      end

      def update(*)
        unsubscribe(flow: object)
      end
    end
  end
end
