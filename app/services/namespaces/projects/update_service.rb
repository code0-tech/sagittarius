# frozen_string_literal: true

module Namespaces
  module Projects
    class UpdateService
      include Sagittarius::Database::Transactional

      attr_reader :current_authentication, :namespace_project, :params

      def initialize(current_authentication, namespace_project, **params)
        @current_authentication = current_authentication
        @namespace_project = namespace_project
        @params = params
      end

      def execute
        unless Ability.allowed?(current_authentication, :update_namespace_project, namespace_project)
          return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
        end

        transactional do |t|
          success = namespace_project.update(params)
          unless success
            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to update namespace project',
              payload: namespace_project.errors
            )
          end

          if params.key?(:primary_runtime)
            runtime = params[:primary_runtime]

            if runtime.namespace != namespace_project.namespace
              return ServiceResponse.error(
                message: 'Primary runtime must belong to the same namespace as the project',
                payload: :invalid_primary_runtime
              )
            end

            params[:primary_runtime_id] = runtime.id if runtime.is_a?(Runtime)
            params.delete(:primary_runtime)
          end

          AuditService.audit(
            :namespace_project_updated,
            author_id: current_authentication.user.id,
            entity: namespace_project,
            target: namespace_project,
            details: params
          )

          ServiceResponse.success(message: 'Updated project', payload: namespace_project)
        end
      end
    end
  end
end
