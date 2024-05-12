# frozen_string_literal: true

module Mutations
  module OrganizationProjects
    class Update < BaseMutation
      description 'Updates a organization project.'

      field :organization_project, Types::OrganizationProjectType, null: true, description: 'The updated project.'

      argument :organization_project_id, Types::GlobalIdType[::OrganizationProject],
               description: 'The id of the organization project which will be updated'

      argument :description, String, required: false, description: 'Description for the updated organization project.'
      argument :name, String, required: false, description: 'Name for the updated organization project.'

      def resolve(organization_project_id:, **params)
        project = SagittariusSchema.object_from_id(organization_project_id)

        if project.nil?
          return { organization_project: nil,
                   errors: [create_message_error('Invalid project')] }
        end

        ::OrganizationProjects::UpdateService.new(
          current_user,
          project,
          **params
        ).execute.to_mutation_response(success_key: :organization_project)
      end
    end
  end
end
