# frozen_string_literal: true

module TeamMembers
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
      team = member.team
      unless Ability.allowed?(current_user, :assign_member_roles, team)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      unless roles.map(&:team).all? { |t| t == team }
        return ServiceResponse.error(message: 'Roles and member belong to different teams', payload: :inconsistent_team)
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

        new_roles = member.reload.member_roles

        AuditService.audit(
          :organization_member_roles_updated,
          author_id: current_user.id,
          entity: member,
          details: {
            old_roles: old_roles_for_audit_event,
            new_roles: new_roles.map { |member_role| { id: member_role.role.id, name: member_role.role.name } },
          },
          target: team
        )

        ServiceResponse.success(message: 'Member roles updated', payload: new_roles)
      end
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity
  end
end
