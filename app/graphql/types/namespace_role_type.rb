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

    id_field ::NamespaceRole
    timestamps

    def abilities
      object.abilities.map(&:ability)
    end
  end
end
