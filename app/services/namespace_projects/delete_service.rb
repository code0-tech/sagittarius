# frozen_string_literal: true

module NamespaceProjects
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :namespace_project

    def initialize(current_user, namespace_project)
      @current_user = current_user
      @namespace_project = namespace_project
    end

    def execute
      unless Ability.allowed?(current_user, :delete_namespace_project, namespace_project)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        namespace_project.delete

        if namespace_project.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to delete project',
            payload: namespace_project.errors
          )
        end

        AuditService.audit(
          :namespace_project_deleted,
          author_id: current_user.id,
          entity: namespace_project,
          target: namespace_project.namespace,
          details: {}
        )

        ServiceResponse.success(message: 'Deleted project', payload: namespace_project)
      end
    end
  end
end
