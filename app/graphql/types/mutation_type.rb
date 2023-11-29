# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'Root Mutation type'

    field :echo, GraphQL::Types::String, null: false,
                                         description: 'Field available for use to test mutation API access' do
      argument :message, GraphQL::Types::String, required: true, description: 'String to echo as response'
    end

    def echo(message:)
      message
    end
  end
end
