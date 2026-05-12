# frozen_string_literal: true

module Types
  class NamespaceType < Types::BaseObject
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

    field :daily_runtime_usages, Types::DailyRuntimeUsageType.connection_type,
          null: false,
          description: 'Daily runtime usage entries for this namespace' do
      argument :flow_id, Types::GlobalIdType[::Flow],
               required: false,
               description: 'Only return usage entries for this flow'
      argument :from, Types::DateType,
               required: false,
               description: 'Only return usage entries on or after this day'
      argument :to, Types::DateType,
               required: false,
               description: 'Only return usage entries on or before this day'
    end
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

    id_field Namespace
    timestamps

    def project(id:)
      object.projects.find_by(id: id.model_id)
    end

    def daily_runtime_usages(flow_id: nil, from: nil, to: nil)
      scope = object.daily_runtime_usages.order(day: :desc, id: :desc)
      scope = scope.where(flow_id: flow_id.model_id) if flow_id.present?
      scope = scope.where(DailyRuntimeUsage.arel_table[:day].gteq(from)) if from.present?
      scope = scope.where(DailyRuntimeUsage.arel_table[:day].lteq(to)) if to.present?
      scope
    end
  end
end

Types::NamespaceType.prepend_extensions
