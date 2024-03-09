# frozen_string_literal: true

module Types
  class OrganizationRoleType < BaseObject
    description 'Represents an organization role.'

    authorize :read_organization_role

    field :abilities, [Types::OrganizationRoleAbilityEnum], null: false,
                                                            description: 'The abilities the role is granted'
    field :name, String, null: false, description: 'The name of this role'
    field :team, Types::TeamType, null: false, description: 'The organization where this role belongs to'

    id_field ::OrganizationRole
    timestamps

    def abilities
      object.abilities.map(&:ability)
    end
  end
end
