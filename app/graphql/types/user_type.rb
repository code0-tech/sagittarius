# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description 'Represents a user'

    authorize :read_user

    field :email, String, null: false, description: 'Email of the user'
    field :username, String, null: false, description: 'Username of the user'

    id_field User
    timestamps
  end
end
