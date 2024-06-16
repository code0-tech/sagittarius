# frozen_string_literal: true

module Types
  class NamespaceMemberRoleType < BaseObject
    description 'Represents an assigned role to a member'

    authorize :read_namespace_member_role

    field :member, Types::NamespaceMemberType, description: 'The member the role is assigned to'
    field :role, Types::NamespaceRoleType, description: 'The assigned role'

    id_field NamespaceMemberRole
    timestamps
  end
end
