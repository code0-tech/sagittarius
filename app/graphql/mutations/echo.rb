# frozen_string_literal: true

module Mutations
  class Echo < BaseMutation
    description <<~DOC
      A mutation that does not perform any changes.

      This is expected to be used for testing of endpoints, to verify
      that a user has mutation access.
    DOC

    argument :message,
             type: ::GraphQL::Types::String,
             required: false,
             description: 'Message to return to the user.'

    field :message,
          type: ::GraphQL::Types::String,
          null: true,
          description: 'Message returned to the user.'

    def resolve(**args)
      args
    end
  end
end
