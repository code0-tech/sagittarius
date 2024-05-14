# frozen_string_literal: true

module OrganizationProjects
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :organization, :name, :params

    def initialize(current_user, organization:, name:, **params)
      @current_user = current_user
      @organization = organization
      @name = name
      @params = params
    end

    def execute
      unless Ability.allowed?(current_user, :create_organization_project, organization)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        project = OrganizationProject.create(organization: organization, name: name, **params)
        unless project.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to create project',
            payload: project.errors
          )
        end

        AuditService.audit(
          :organization_project_created,
          author_id: current_user.id,
          entity: project,
          target: organization,
          details: {
            name: name,
            **params,
          }
        )

        ServiceResponse.success(message: 'Created new project', payload: project)
      end
    end
  end
end
