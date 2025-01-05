# frozen_string_literal: true

module NamespaceProjects
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :namespace, :name, :params

    def initialize(current_authentication, namespace:, name:, **params)
      @current_authentication = current_authentication
      @namespace = namespace
      @name = name
      @params = params
    end

    def execute
      unless Ability.allowed?(current_authentication, :create_namespace_project, namespace)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        project = NamespaceProject.create(namespace: namespace, name: name, **params)
        unless project.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to create project',
            payload: project.errors
          )
        end

        AuditService.audit(
          :namespace_project_created,
          author_id: current_authentication.user.id,
          entity: project,
          target: namespace,
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
