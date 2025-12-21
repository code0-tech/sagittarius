# frozen_string_literal: true

module Namespaces
  module Projects
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
          return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
        end

        transactional do |t|
          unless params.key?(:slug)
            slug = name.parameterize

            tries_left = 5
            while NamespaceProject.exists?(slug: slug) && tries_left.positive?
              slug = "#{slug}-#{SecureRandom.hex(4)}"
              tries_left -= 1
            end
            params[:slug] = slug
          end

          project = NamespaceProject.create(namespace: namespace, name: name, **params)
          unless project.persisted?
            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to create project',
              error_code: :invalid_namespace_project,
              details: project.errors
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
end
