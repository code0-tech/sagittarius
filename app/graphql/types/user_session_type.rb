# frozen_string_literal: true

module Types
  class UserSessionType < Types::BaseObject
    description 'Represents a user session'

    authorize :read_user_session

    field :active, GraphQL::Types::Boolean, null: false,
                                            description: 'Whether or not the session is active and can be used'
    field :token, String, null: true, description: 'Token belonging to the session, only present on creation'
    field :user, Types::UserType, null: false, description: 'User that belongs to the session'

    id_field UserSession
    timestamps

    def token
      object.token if object.id_previously_changed?
    end
  end
end
