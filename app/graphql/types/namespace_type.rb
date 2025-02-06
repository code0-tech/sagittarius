# frozen_string_literal: true

module Types
  class NamespaceType < Types::BaseObject
    description 'Represents a Namespace'

    authorize :read_namespace

    field :parent, Types::NamespaceParentType, null: false, description: 'Parent of this namespace'

    field :projects, ::Types::NamespaceProjectType.connection_type,
          null: false,
          description: 'Projects of the namespace'

    field :members, Types::NamespaceMemberType.connection_type, null: false,
                                                                description: 'Members of the namespace',
                                                                extras: [:lookahead]

    field :datatypes, Types::DataTypeType.connection_type, null: false, description: 'DataTypes of the namespace'
    field :roles, Types::NamespaceRoleType.connection_type, null: false, description: 'Roles of the namespace'
    field :runtimes, Types::RuntimeType.connection_type, null: false, description: 'Runtime of the namespace'

    lookahead_field :members, base_scope: ->(object) { object.namespace_members },
                              conditional_lookaheads: { user: :user, namespace: :namespace }

    id_field Namespace
    timestamps
  end
end

Types::NamespaceType.prepend_extensions
