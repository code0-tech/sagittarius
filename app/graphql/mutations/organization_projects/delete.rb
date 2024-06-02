# frozen_string_literal: true

module Mutations
  module OrganizationProjects
    class Delete < BaseMutation
      description 'Updates a organization project.'

      field :organization_project, Types::OrganizationProjectType, null: true, description: 'The deleted project.'

      argument :organization_project_id, Types::GlobalIdType[::OrganizationProject],
               description: 'The id of the organization project which will be updated'

      def resolve(organization_project_id:)
        project = SagittariusSchema.object_from_id(organization_project_id)

        if project.nil?
          return { organization_project: nil,
                   errors: [create_message_error('Invalid project')] }
        end

        ::OrganizationProjects::DeleteService.new(
          current_user,
          project
        ).execute.to_mutation_response(success_key: :organization_project)
      end
    end
  end
end
