# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description 'Represents a user'

    authorize :read_user

    field :email, String, null: false, description: 'Email of the user'
    field :username, String, null: false, description: 'Username of the user'

    field :team_memberships, Types::TeamMemberType.connection_type, null: false,
                                                                    description: 'Team Memberships of this user',
                                                                    extras: [:lookahead]

    lookahead_field :team_memberships, base_scope: ->(object) { object.team_memberships },
                                       conditional_lookaheads: { user: :user, team: { team: :team_members } }

    id_field User
    timestamps
  end
end
