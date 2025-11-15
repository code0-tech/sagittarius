# frozen_string_literal: true

module Mutations
  module Namespaces
    module Projects
      class Update < BaseMutation
        description 'Updates a namespace project.'

        field :namespace_project, Types::NamespaceProjectType, null: true, description: 'The updated project.'

        argument :namespace_project_id, Types::GlobalIdType[::NamespaceProject],
                 description: 'The id of the namespace project which will be updated'

        argument :description, String, required: false, description: 'Description for the updated project.'
        argument :name, String, required: false, description: 'Name for the updated project.'
        argument :primary_runtime_id, Types::GlobalIdType[::Runtime],
                 required: false, description: 'The primary runtime for the updated project.'

        def resolve(namespace_project_id:, **params)
          project = SagittariusSchema.object_from_id(namespace_project_id)

          if project.nil?
            return { organization_project: nil,
                     errors: [create_error(:project_not_found, 'Invalid project')] }
          end

          params[:primary_runtime_id] = params[:primary_runtime_id]&.model_id if params.key?(:primary_runtime_id)

          ::Namespaces::Projects::UpdateService.new(
            current_authentication,
            project,
            **params
          ).execute.to_mutation_response(success_key: :namespace_project)
        end
      end
    end
  end
end
