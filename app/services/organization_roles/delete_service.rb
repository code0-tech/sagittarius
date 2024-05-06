# frozen_string_literal: true

module OrganizationRoles
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :organization_role

    def initialize(current_user, organization_role)
      @current_user = current_user
      @organization_role = organization_role
    end

    def execute
      unless Ability.allowed?(current_user, :delete_organization_role, organization_role)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      unless organization_role.organization.roles.where.not(id: organization_role.id)
                              .joins(:abilities)
                              .exists?(abilities: { ability: :organization_administrator })
        return ServiceResponse.error(message: 'Cannot delete last administrator role',
                                     payload: :cannot_delete_last_admin_role)
      end

      transactional do
        organization_role.delete

        if organization_role.persisted?
          return ServiceResponse.error(message: 'Failed to delete organization role', payload: organization_role.errors)
        end

        AuditService.audit(
          :organization_role_deleted,
          author_id: current_user.id,
          entity: organization_role,
          details: {},
          target: organization_role.organization
        )

        ServiceResponse.success(message: 'Organization role deleted', payload: organization_role)
      end
    end
  end
end
