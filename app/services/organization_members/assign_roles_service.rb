# frozen_string_literal: true

module OrganizationMembers
  class AssignRolesService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :member, :roles

    def initialize(current_user, member, roles)
      @current_user = current_user
      @member = member
      @roles = roles
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def execute
      organization = member.organization
      unless Ability.allowed?(current_user, :assign_member_roles, organization)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      unless roles.map(&:organization).all? { |t| t == organization }
        return ServiceResponse.error(
          message: 'Roles and member belong to different organizations',
          payload: :inconsistent_organization
        )
      end

      transactional do |t|
        current_roles = member.member_roles.preload(:role)
        old_roles_for_audit_event = current_roles.map do |member_role|
          { id: member_role.role.id, name: member_role.role.name }
        end

        current_roles.where.not(role: roles).delete_all

        (roles - current_roles.map(&:role)).map do |role|
          organization_member_role = OrganizationMemberRole.create(member: member, role: role)

          next if organization_member_role.persisted?

          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to save organization member role',
            payload: organization_member_role.errors
          )
        end

        check_last_admin_user(t)

        new_roles = member.reload.member_roles

        create_audit_event(new_roles, old_roles_for_audit_event, organization)

        ServiceResponse.success(message: 'Member roles updated', payload: new_roles)
      end
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity

    private

    def create_audit_event(new_roles, old_roles_for_audit_event, organization)
      AuditService.audit(
        :organization_member_roles_updated,
        author_id: current_user.id,
        entity: member,
        details: {
          old_roles: old_roles_for_audit_event,
          new_roles: new_roles.map { |member_role| { id: member_role.role.id, name: member_role.role.name } },
        },
        target: organization
      )
    end

    def check_last_admin_user(t)
      unless member.organization.roles
                   .joins(:abilities, :member_roles)
                   .exists?(abilities: { ability: :organization_administrator })
        t.rollback_and_return! ServiceResponse.error(
          message: 'Cannot remove last administrator from organization',
          payload: :cannot_remove_last_administrator
        )
      end
    end
  end
end
