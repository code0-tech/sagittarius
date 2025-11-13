# frozen_string_literal: true

module Mutations
  module Namespaces
    module Projects
      class AssignRuntimes < BaseMutation
        description 'Assign runtimes to a project'

        argument :namespace_project_id, Types::GlobalIdType[::NamespaceProject],
                 description: 'ID of the project to assign runtimes to'
        argument :runtime_ids, [Types::GlobalIdType[::Runtime]], description: 'The new runtimes assigned to the project'

        field :namespace_project, Types::NamespaceProjectType, null: true,
                                                               description: 'The updated project with assigned runtimes'

        def resolve(namespace_project_id:, runtime_ids:)
          namespace_project = SagittariusSchema.object_from_id(namespace_project_id)
          runtimes = runtime_ids.map { |runtime_id| SagittariusSchema.object_from_id(runtime_id) }

          if namespace_project.nil?
            return { namespace_project: nil,
                     errors: [create_error(:project_not_found, 'Invalid project')] }
          end
          if runtimes.any?(&:nil?)
            return { namespace_project: nil,
                     errors: [create_error(:runtime_not_found, 'Invalid runtime')] }
          end

          ::Namespaces::Projects::AssignRuntimesService.new(
            current_authentication,
            namespace_project,
            runtimes
          ).execute.to_mutation_response(success_key: :namespace_project)
        end
      end
    end
  end
end
