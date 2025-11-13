# frozen_string_literal: true

module Types
  class NamespaceRoleType < BaseObject
    description 'Represents a namespace role.'

    authorize :read_namespace_role

    field :abilities, [Types::NamespaceRoleAbilityEnum], null: false,
                                                         description: 'The abilities the role is granted'
    field :name, String, null: false, description: 'The name of this role'
    field :namespace, Types::NamespaceType, null: true,
                                            description: 'The namespace where this role belongs to'

    field :assigned_projects, Types::NamespaceProjectType.connection_type,
          description: 'The projects this role is assigned to'

    field :assigned_members, Types::NamespaceProjectType.connection_type,
          description: 'The projects this role is assigned to'

    expose_abilities %i[
      assign_role_abilities
      assign_role_projects
      delete_namespace_role
      update_namespace_role
    ]

    id_field ::NamespaceRole
    timestamps

    def abilities
      object.abilities.map(&:ability)
    end
  end
end
