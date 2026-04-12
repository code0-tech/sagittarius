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
          return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
        end

        params[:primary_runtime_id] = params.delete(:primary_runtime)&.id if params.key?(:primary_runtime)

        transactional do |t|
          validate_new_primary_runtime(params[:primary_runtime_id], t) if params.key?(:primary_runtime_id)

          namespace_project.assign_attributes(params)

          if namespace_project.primary_runtime_changed?
            UpdateRuntimeCompatibilityJob.perform_later({ namespace_project_id: namespace_project.id })
            ReassignProjectFlowDefinitionsJob.perform_later(namespace_project.id)
          end

          unless namespace_project.save
            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to update namespace project',
              error_code: :invalid_namespace_project,
              details: namespace_project.errors
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

      private

      def validate_new_primary_runtime(runtime_id, t)
        assignment = namespace_project.runtime_assignments.find_by(runtime_id: runtime_id)

        if assignment.blank?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Runtime not assigned to project',
            error_code: :runtime_not_assigned
          )
        end

        return if namespace_project.primary_runtime.blank?
        return if assignment.compatible

        t.rollback_and_return! ServiceResponse.error(
          message: 'Runtime not compatible with primary runtime',
          error_code: :runtime_not_compatible
        )
      end
    end
  end
end
