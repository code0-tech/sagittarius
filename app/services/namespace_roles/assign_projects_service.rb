# frozen_string_literal: true

module NamespaceRoles
  class AssignProjectsService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :role, :projects

    def initialize(current_user, role, projects)
      @current_user = current_user
      @role = role
      @projects = projects
    end

    def execute
      namespace = role.namespace
      unless Ability.allowed?(current_user, :assign_role_projects, namespace)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do |t|
        current_projects = role.project_assignments
        old_projects_for_audit_event = current_projects.map(&:project).map do |project|
          { name: project.name, id: project.id }
        end

        current_projects.where.not(project: projects).delete_all

        (projects - current_projects.map(&:project)).map do |projects|
          project_assignment = NamespaceRoleProjectAssignment.create(role: role, project: projects)

          next if project_assignment.persisted?

          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to save namespace role project assignment',
            payload: project_assignment.errors
          )
        end

        new_projects = role.reload.project_assignments.map(&:project)

        AuditService.audit(
          :namespace_role_projects_updated,
          author_id: current_user.id,
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
