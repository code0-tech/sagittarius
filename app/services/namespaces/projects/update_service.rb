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

        params[:primary_runtime_id] = params.delete(:primary_runtime)&.id if params.key?(:primary_runtime)

        transactional do |t|
          success = namespace_project.update(params)
          unless success
            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to update namespace project',
              payload: namespace_project.errors
            )
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
