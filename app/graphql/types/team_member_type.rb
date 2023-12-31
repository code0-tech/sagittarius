# frozen_string_literal: true

module Types
  class TeamMemberType < Types::BaseObject
    description 'Represents a Team member'

    authorize :read_team_member

    field :team, Types::TeamType, null: false, description: 'Team this member belongs to'
    field :user, Types::UserType, null: false, description: 'User this member belongs to'

    id_field TeamMember
    timestamps
  end
end
