# frozen_string_literal: true

module Namespaces
  module Roles
    class AssignProjectsService
      include Sagittarius::Database::Transactional

      attr_reader :current_authentication, :role, :projects

      def initialize(current_authentication, role, projects)
        @current_authentication = current_authentication
        @role = role
        @projects = projects
      end

      def execute
        namespace = role.namespace
        unless Ability.allowed?(current_authentication, :assign_role_projects, role)
          return ServiceResponse.error(message: 'Missing permissions', error_code: :missing_permission)
        end

        transactional do |t|
          current_projects = role.namespace_role_project_assignments
          old_projects_for_audit_event = current_projects.map(&:namespace_project).map do |project|
            { name: project.name, id: project.id }
          end

          current_projects.where.not(namespace_project: projects).delete_all

          (projects - current_projects.map(&:namespace_project)).map do |projects|
            project_assignment = NamespaceRoleProjectAssignment.create(
              namespace_role: role, namespace_project: projects
            )

            next if project_assignment.persisted?

            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to save namespace role project assignment',
              payload: project_assignment.errors
            )
          end

          new_projects = role.reload.namespace_role_project_assignments.map(&:namespace_project)

          AuditService.audit(
            :namespace_role_projects_updated,
            author_id: current_authentication.user.id,
            entity: role,
            details: {
              old_projects: old_projects_for_audit_event,
              new_projects: new_projects.map { |project| { name: project.name, id: project.id } },
            },
            target: namespace
          )

          ServiceResponse.success(message: 'Role project assignments updated', payload: new_projects)
        end
      end
    end
  end
end
