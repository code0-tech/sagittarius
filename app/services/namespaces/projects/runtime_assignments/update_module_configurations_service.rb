# frozen_string_literal: true

module Namespaces
  module Projects
    module RuntimeAssignments
      class UpdateModuleConfigurationsService
        include Sagittarius::Database::Transactional

        attr_reader :current_authentication, :runtime_assignment, :module_configurations

        def initialize(current_authentication, runtime_assignment, module_configurations)
          @current_authentication = current_authentication
          @runtime_assignment = runtime_assignment
          @module_configurations = module_configurations
        end

        def execute
          unless Ability.allowed?(
            current_authentication,
            :assign_project_runtimes,
            runtime_assignment.namespace_project
          )
            return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
          end

          response = transactional do |t|
            db_configurations = update_configurations(t)

            AuditService.audit(
              :project_module_configurations_updated,
              author_id: current_authentication.user.id,
              entity: runtime_assignment,
              target: runtime_assignment.namespace_project,
              details: {
                runtime_assignment_id: runtime_assignment.id,
                module_configurations: db_configurations.map do |configuration|
                  {
                    id: configuration.id,
                    module_configuration_definition_id: configuration.module_configuration_definition_id,
                  }
                end,
              }
            )

            ServiceResponse.success(message: 'Updated module configurations', payload: runtime_assignment)
          end

          return response if response.error?

          FlowHandler.update_runtime(runtime_assignment.runtime)
          response
        end

        private

        def update_configurations(t)
          existing_configurations = runtime_assignment.module_configurations.index_by(
            &:module_configuration_definition_id
          )
          db_configurations = []
          kept_definition_ids = []

          module_configurations.each do |configuration_input|
            definition = runtime_assignment.runtime.module_configuration_definitions.find_by(
              id: configuration_input.module_configuration_definition_id.model_id
            )

            if definition.nil?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Invalid module configuration definition',
                error_code: :invalid_module_configuration_definition
              )
            end

            db_configuration = existing_configurations[definition.id] || runtime_assignment.module_configurations.build
            db_configuration.module_configuration_definition = definition
            db_configuration.value = configuration_input.try(:value)

            unless db_configuration.save
              t.rollback_and_return! ServiceResponse.error(
                message: 'Invalid module configuration',
                error_code: :invalid_module_configuration,
                details: db_configuration.errors
              )
            end

            kept_definition_ids << definition.id
            db_configurations << db_configuration
          end

          runtime_assignment.module_configurations
                            .where.not(module_configuration_definition_id: kept_definition_ids)
                            .destroy_all

          db_configurations
        end
      end
    end
  end
end
