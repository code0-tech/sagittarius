# frozen_string_literal: true

module Mutations
  module NamespaceRoles
    class AssignProjects < BaseMutation
      description 'Update the project a role is assigned to.'

      field :projects, [Types::NamespaceProjectType], description: 'The now assigned projects'

      argument :project_ids, [Types::GlobalIdType[::NamespaceProject]],
               description: 'The projects that should be assigned to the role'
      argument :role_id, Types::GlobalIdType[::NamespaceRole],
               description: 'The id of the role which should be assigned to projects'

      def resolve(role_id:, project_ids:)
        role = SagittariusSchema.object_from_id(role_id)
        projects = project_ids.map { |id| SagittariusSchema.object_from_id(id) }

        return { projects: nil, errors: [create_message_error('Invalid role')] } if role.nil?
        return { projects: nil, errors: [create_message_error('Invalid project')] } if projects.any?(&:nil?)

        ::NamespaceRoles::AssignProjectsService.new(
          current_user,
          role,
          projects
        ).execute.to_mutation_response(success_key: :projects)
      end
    end
  end
end
