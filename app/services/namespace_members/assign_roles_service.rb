# frozen_string_literal: true

module NamespaceMembers
  class AssignRolesService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :member, :roles

    def initialize(current_authentication, member, roles)
      @current_authentication = current_authentication
      @member = member
      @roles = roles
    end

    def execute
      namespace = member.namespace
      unless Ability.allowed?(current_authentication, :assign_member_roles, namespace)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      unless roles.map(&:namespace).all? { |t| t == namespace }
        return ServiceResponse.error(
          message: 'Roles and member belong to different namespaces',
          payload: :inconsistent_namespace
        )
      end

      transactional do |t|
        current_roles = member.member_roles.preload(:role)
        old_roles_for_audit_event = current_roles.map do |member_role|
          { id: member_role.role.id, name: member_role.role.name }
        end

        current_roles.where.not(role: roles).delete_all

        (roles - current_roles.map(&:role)).map do |role|
          namespace_member_role = NamespaceMemberRole.create(member: member, role: role)

          next if namespace_member_role.persisted?

          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to save namespace member role',
            payload: namespace_member_role.errors
          )
        end

        check_last_admin_user(t)

        new_roles = member.reload.member_roles

        create_audit_event(new_roles, old_roles_for_audit_event, namespace)

        ServiceResponse.success(message: 'Member roles updated', payload: new_roles)
      end
    end

    private

    def create_audit_event(new_roles, old_roles_for_audit_event, namespace)
      AuditService.audit(
        :namespace_member_roles_updated,
        author_id: current_authentication.user.id,
        entity: member,
        details: {
          old_roles: old_roles_for_audit_event,
          new_roles: new_roles.map { |member_role| { id: member_role.role.id, name: member_role.role.name } },
        },
        target: namespace
      )
    end

    def check_last_admin_user(t)
      return if member.namespace.has_owner?

      unless member.namespace.roles
                   .joins(:abilities, :member_roles)
                   .exists?(abilities: { ability: :namespace_administrator })
        t.rollback_and_return! ServiceResponse.error(
          message: 'Cannot remove last administrator from namespace',
          payload: :cannot_remove_last_administrator
        )
      end
    end
  end
end
