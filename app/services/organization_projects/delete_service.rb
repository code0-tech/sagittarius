# frozen_string_literal: true

module OrganizationProjects
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :organization_project

    def initialize(current_user, organization_project)
      @current_user = current_user
      @organization_project = organization_project
    end

    def execute
      unless Ability.allowed?(current_user, :delete_organization_project, organization_project.organization)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        organization_project.delete

        if organization_project.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to delete project',
            payload: organization_project.errors
          )
        end

        AuditService.audit(
          :organization_project_deleted,
          author_id: current_user.id,
          entity: organization_project,
          target: organization_project,
          details: { organization_id: organization_project.organization.id }
        )

        ServiceResponse.success(message: 'Created new project', payload: organization_project)
      end
    end
  end
end
