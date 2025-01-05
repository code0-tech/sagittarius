# frozen_string_literal: true

module Mutations
  module NamespaceProjects
    class Create < BaseMutation
      description 'Creates a new namespace project.'

      field :namespace_project, Types::NamespaceProjectType, null: true, description: 'The newly created project.'

      argument :namespace_id, Types::GlobalIdType[::Namespace],
               description: 'The id of the namespace which this project will belong to'

      argument :description, String, required: false, description: 'Description for the new project.'
      argument :name, String, required: true, description: 'Name for the new project.'

      def resolve(namespace_id:, **params)
        namespace = SagittariusSchema.object_from_id(namespace_id)

        if namespace.nil?
          return { organization_project: nil,
                   errors: [create_message_error('Invalid namespace')] }
        end

        ::NamespaceProjects::CreateService.new(
          current_authentication,
          namespace: namespace,
          **params
        ).execute.to_mutation_response(success_key: :namespace_project)
      end
    end
  end
end
