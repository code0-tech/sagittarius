# frozen_string_literal: true

module Types
  class NamespaceType < Types::BaseObject
    include Types::Concerns::HasRuntimeUsageField
    include Types::Concerns::HasAiUsageField

    description 'Represents a Namespace'

    authorize :read_namespace

    field :parent, Types::NamespaceParentType, null: false, description: 'Parent of this namespace'

    field :project, Types::NamespaceProjectType, null: true, description: 'Query a project by its id' do
      argument :id, Types::GlobalIdType[::NamespaceProject], required: true,
                                                             description: 'GlobalID of the target project'
    end
    field :projects, ::Types::NamespaceProjectType.connection_type,
          null: false,
          description: 'Projects of the namespace'

    field :members, Types::NamespaceMemberType.connection_type, null: false,
                                                                description: 'Members of the namespace',
                                                                extras: [:lookahead]

    field :roles, Types::NamespaceRoleType.connection_type, null: false, description: 'Roles of the namespace'
    field :runtimes, Types::RuntimeType.connection_type, null: false, description: 'Runtime of the namespace'

    lookahead_field :members, base_scope: ->(object) { object.namespace_members },
                              conditional_lookaheads: { user: :user, namespace: :namespace }

    expose_abilities %i[
      invite_member
      create_namespace_role
      create_namespace_project
      create_runtime
    ]

    runtime_usage_field description: 'Execution usage of this namespace, bucketed by day, week or month'
    ai_usage_field description: 'AI generation usage of this namespace, bucketed by day, week or month'

    id_field Namespace
    timestamps

    def project(id:)
      object.projects.find_by(id: id.model_id)
    end
  end
end

Types::NamespaceType.prepend_extensions
