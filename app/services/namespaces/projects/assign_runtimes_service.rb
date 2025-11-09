# frozen_string_literal: true

module Namespaces
  module Projects
    class AssignRuntimesService
      include Sagittarius::Database::Transactional

      attr_reader :current_authentication, :namespace_project, :runtimes

      def initialize(current_authentication, namespace_project, runtimes)
        @current_authentication = current_authentication
        @namespace_project = namespace_project
        @runtimes = runtimes
      end

      def execute
        unless Ability.allowed?(current_authentication, :assign_project_runtimes, namespace_project)
          return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
        end

        transactional do |t|
          old_assignments_for_audit_event = namespace_project.runtime_assignments.map do |assignment|
            { id: assignment.runtime.id }
          end

          namespace_project.runtimes = runtimes
          unless namespace_project.save
            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to assign runtimes to project',
              error_code: :invalid_namespace_project,
              details: namespace_project.errors
            )
          end

          UpdateRuntimeCompatibilityJob.perform_later(namespace_project_id: namespace_project.id)

          AuditService.audit(
            :project_runtimes_assigned,
            author_id: current_authentication.user.id,
            entity: namespace_project,
            target: namespace_project,
            details: {
              new_runtimes: runtimes.map { |runtime| { id: runtime.id } },
              old_runtimes: old_assignments_for_audit_event,
            }
          )

          ServiceResponse.success(message: 'Assigned runtimes to a project', payload: namespace_project)
        end
      end
    end
  end
end
