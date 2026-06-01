# frozen_string_literal: true

module Subscriptions
  class Echo < BaseSubscription
    description <<~DOC
      A subscription that does not perform any real updates.

      This is expected to be used for testing of endpoints, to verify
      that a user has subscription access.
    DOC

    argument :message,
             type: GraphQL::Types::String,
             required: false,
             description: 'Message to return to the user.'

    field :message,
          type: GraphQL::Types::String,
          null: true,
          description: 'Message returned to the user.'

    def subscribe(message: nil)
      { message: message }
    end

    def update(*)
      { message: object[:message] }
    end
  end
end
