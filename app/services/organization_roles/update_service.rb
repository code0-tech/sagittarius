# frozen_string_literal: true

module OrganizationRoles
  class UpdateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :organization_role, :params

    def initialize(current_user, organization_role, params)
      @current_user = current_user
      @organization_role = organization_role
      @params = params
    end

    def execute
      unless Ability.allowed?(current_user, :update_organization_role, organization_role)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        success = organization_role.update(params)
        unless success
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to update organization role',
            payload: organization_role.errors
          )
        end

        AuditService.audit(
          :organization_role_updated,
          author_id: current_user.id,
          entity: organization_role,
          target: organization_role,
          details: params
        )

        ServiceResponse.success(message: 'Updated organization role', payload: organization_role)
      end
    end
  end
end
