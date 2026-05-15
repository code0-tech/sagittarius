# frozen_string_literal: true

module Types
  class CraterTokenType < BaseObject
    description 'Represents a token for crater authentication'

    field :user, Types::UserType, null: false, description: 'The user this token authenticates'

    field :token, GraphQL::Types::String, null: true, description: 'The created token'
  end
end
