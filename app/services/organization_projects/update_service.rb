# frozen_string_literal: true

module OrganizationProjects
  class UpdateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :organization_project, :params

    def initialize(current_user, organization_project, **params)
      @current_user = current_user
      @organization_project = organization_project
      @params = params
    end

    def execute
      unless Ability.allowed?(current_user, :update_organization_project, organization_project.organization)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        success = organization_project.update(params)
        unless success
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to update organization project',
            payload: organization_project.errors
          )
        end

        AuditService.audit(
          :organization_project_updated,
          author_id: current_user.id,
          entity: organization_project,
          target: organization_project,
          details: params
        )

        ServiceResponse.success(message: 'Updated project', payload: organization_project)
      end
    end
  end
end
