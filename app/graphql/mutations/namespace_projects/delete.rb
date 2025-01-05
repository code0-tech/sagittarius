# frozen_string_literal: true

module Mutations
  module NamespaceProjects
    class Delete < BaseMutation
      description 'Deletes a namespace project.'

      field :namespace_project, Types::NamespaceProjectType, null: true, description: 'The deleted project.'

      argument :namespace_project_id, Types::GlobalIdType[::NamespaceProject],
               description: 'The id of the namespace project which will be deleted'

      def resolve(namespace_project_id:)
        project = SagittariusSchema.object_from_id(namespace_project_id)

        if project.nil?
          return { organization_project: nil,
                   errors: [create_message_error('Invalid project')] }
        end

        ::NamespaceProjects::DeleteService.new(
          current_authentication,
          project
        ).execute.to_mutation_response(success_key: :namespace_project)
      end
    end
  end
end
