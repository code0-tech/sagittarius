# frozen_string_literal: true

module Types
  class TeamRoleType < BaseObject
    description 'Represents a team role.'

    authorize :read_team_role

    field :abilities, [Types::TeamRoleAbilityEnum], null: false, description: 'The abilities the role is granted'
    field :name, String, null: false, description: 'The name of this role'
    field :team, Types::TeamType, null: false, description: 'The team where this role belongs to'

    id_field ::TeamRole
    timestamps

    def abilities
      object.abilities.map(&:ability)
    end
  end
end
