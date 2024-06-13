# frozen_string_literal: true

module Mutations
  module NamespaceProjects
    class Update < BaseMutation
      description 'Updates a namespace project.'

      field :namespace_project, Types::NamespaceProjectType, null: true, description: 'The updated project.'

      argument :namespace_project_id, Types::GlobalIdType[::NamespaceProject],
               description: 'The id of the namespace project which will be updated'

      argument :description, String, required: false, description: 'Description for the updated project.'
      argument :name, String, required: false, description: 'Name for the updated project.'

      def resolve(namespace_project_id:, **params)
        project = SagittariusSchema.object_from_id(namespace_project_id)

        if project.nil?
          return { organization_project: nil,
                   errors: [create_message_error('Invalid project')] }
        end

        ::NamespaceProjects::UpdateService.new(
          current_user,
          project,
          **params
        ).execute.to_mutation_response(success_key: :namespace_project)
      end
    end
  end
end
