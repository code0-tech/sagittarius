# frozen_string_literal: true

module Types
  class TeamRoleType < BaseObject
    description 'Represents a team role.'

    authorize :read_team_role

    field :name, String, null: false, description: 'The name of this role'
    field :team, Types::TeamType, null: false, description: 'The team where this role belongs to'

    id_field ::TeamRole
    timestamps
  end
end
