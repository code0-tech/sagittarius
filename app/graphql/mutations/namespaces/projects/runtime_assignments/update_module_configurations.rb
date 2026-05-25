# frozen_string_literal: true

module Mutations
  module Namespaces
    module Projects
      module RuntimeAssignments
        class UpdateModuleConfigurations < BaseMutation
          description 'Updates the saved module configurations for a project runtime assignment.'

          argument :module_configurations, [Types::Input::ModuleConfigurationInputType],
                   required: true,
                   description: 'The full set of saved module configurations for this assignment.'
          argument :namespace_project_runtime_assignment_id,
                   Types::GlobalIdType[::NamespaceProjectRuntimeAssignment],
                   description: 'The project runtime assignment to update.'

          field :namespace_project_runtime_assignment, Types::NamespaceProjectRuntimeAssignmentType,
                null: true,
                description: 'The updated project runtime assignment.'

          def resolve(namespace_project_runtime_assignment_id:, module_configurations:)
            runtime_assignment = SagittariusSchema.object_from_id(namespace_project_runtime_assignment_id)

            if runtime_assignment.nil?
              return {
                namespace_project_runtime_assignment: nil,
                errors: [create_error(:runtime_not_assigned, 'Invalid project runtime assignment')],
              }
            end

            ::Namespaces::Projects::RuntimeAssignments::UpdateModuleConfigurationsService.new(
              current_authentication,
              runtime_assignment,
              module_configurations
            ).execute.to_mutation_response(success_key: :namespace_project_runtime_assignment)
          end
        end
      end
    end
  end
end
