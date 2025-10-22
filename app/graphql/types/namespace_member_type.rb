# frozen_string_literal: true

module Types
  class NamespaceMemberType < Types::BaseObject
    description 'Represents a namespace member'

    authorize :read_namespace_member

    field :namespace, Types::NamespaceType, null: false, description: 'Namespace this member belongs to'
    field :user, Types::UserType, null: false, description: 'User this member belongs to'

    field :member_roles, NamespaceMemberRoleType.connection_type, null: false, description: 'Memberroles of the member'
    field :roles, NamespaceRoleType.connection_type, null: false, description: 'Roles of the member'

    id_field NamespaceMember
    timestamps
  end
end
