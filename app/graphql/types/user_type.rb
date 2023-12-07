# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description 'Represents a user'

    field :email, String, null: false, description: 'Email of the user'
    field :id, Types::GlobalIdType[::User], null: false, description: 'GlobalID of the user'
    field :username, String, null: false, description: 'Username of the user'
  end
end
