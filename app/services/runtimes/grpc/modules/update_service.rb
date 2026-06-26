# frozen_string_literal: true

module Runtimes
  module Grpc
    module Modules
      class UpdateService
        include Sagittarius::Database::Transactional
        include Code0::ZeroTrack::Loggable
        include Runtimes::Grpc::TranslationUpdateHelper

        DEFAULT_DEFINITION_UPDATE_SERVICES = {
          runtime_flow_types: Runtimes::Grpc::RuntimeFlowTypes::UpdateService,
          flow_types: Runtimes::Grpc::FlowTypes::UpdateService,
          runtime_function_definitions: Runtimes::Grpc::RuntimeFunctionDefinitions::UpdateService,
          function_definitions: Runtimes::Grpc::FunctionDefinitions::UpdateService,
          configurations: Runtimes::Grpc::ModuleConfigurationDefinitions::UpdateService,
        }.freeze

        attr_reader :current_runtime, :modules, :definition_update_services

        def initialize(current_runtime, modules, definition_update_services: DEFAULT_DEFINITION_UPDATE_SERVICES)
          @current_runtime = current_runtime
          @modules = modules
          @definition_update_services = definition_update_services
        end

        def execute
          response = transactional do |t|
            lock_existing_modules(t)

            module_records = update_modules(t)
            next module_records unless module_records.success?

            update_data_types(module_records.payload, t)
            update_module_definitions(module_records.payload, t)
            update_definition_services(module_records.payload, t)

            logger.info(message: 'Updated modules for runtime', runtime_id: current_runtime.id)

            ServiceResponse.success(message: 'Updated modules', payload: modules)
          end

          return response if response.error?

          update_runtime_compatibility
          FlowHandler.update_runtime(current_runtime)
          response
        end

        protected

        def update_modules(t)
          module_records = {}

          modules.each do |grpc_module|
            module_record = RuntimeModule.find_or_initialize_by(
              runtime: current_runtime,
              identifier: grpc_module.identifier
            )
            module_record.documentation = grpc_module.documentation
            module_record.author = grpc_module.author
            module_record.icon = grpc_module.icon
            module_record.version = grpc_module.version
            module_record.names = update_translations(grpc_module.name, module_record.names)
            module_record.descriptions = update_translations(grpc_module.description, module_record.descriptions)

            next module_records[grpc_module] = module_record if module_record.save

            logger.error(message: 'Failed to update runtime module',
                         runtime_id: current_runtime.id,
                         module_identifier: grpc_module.identifier,
                         errors: module_record.errors.full_messages)

            return t.rollback_and_return! ServiceResponse.error(message: 'Failed to update runtime module',
                                                                error_code: :invalid_runtime_module,
                                                                details: module_record.errors)
          end

          ServiceResponse.success(payload: module_records)
        end

        def update_data_types(module_records, t)
          data_type_runtime_modules = {}
          data_types = modules.flat_map do |grpc_module|
            runtime_module = module_records.fetch(grpc_module)

            grpc_module.definition_data_types.each do |data_type|
              data_type_runtime_modules[data_type.identifier] = runtime_module
            end
          end

          response = Runtimes::Grpc::DataTypes::UpdateService.new(
            current_runtime,
            data_types,
            runtime_module: nil,
            runtime_module_resolver: ->(data_type) { data_type_runtime_modules.fetch(data_type.identifier) },
            runtime_modules_to_update: module_records.values,
            update_runtime_compatibility: false
          ).execute

          t.rollback_and_return! response unless response.success?
        end

        def update_definition_services(module_records, t)
          definition_update_services.each do |definition_field, service|
            modules.each do |grpc_module|
              runtime_module = module_records.fetch(grpc_module)
              response = build_definition_update_service(
                service,
                grpc_module.public_send(definition_field),
                runtime_module
              ).execute
              t.rollback_and_return! response unless response.success?
            end
          end
        end

        def update_module_definitions(module_records, t)
          modules.each do |grpc_module|
            runtime_module = module_records.fetch(grpc_module)
            db_module_definitions = runtime_module.runtime_module_definitions.first(grpc_module.definitions.length)

            grpc_module.definitions.each_with_index do |definition, index|
              next unless definition.value == :endpoint

              endpoint = definition.endpoint
              db_module_definitions[index] ||= runtime_module.runtime_module_definitions.build
              db_module_definitions[index].nilify_attributes!

              db_module_definitions[index].assign_attributes(
                host: endpoint.host,
                port: endpoint.port,
                endpoint: endpoint.endpoint
              )

              next if db_module_definitions[index].save

              t.rollback_and_return! ServiceResponse.error(
                message: 'Failed to update runtime module definition',
                error_code: :invalid_runtime_module_definition,
                details: db_module_definitions[index].errors
              )
            end

            runtime_module.runtime_module_definitions.excluding(db_module_definitions).delete_all
          end
        end

        def lock_existing_modules(t)
          identifiers = modules.map(&:identifier)
          RuntimeModule.where(runtime: current_runtime, identifier: identifiers)
                       .order(:id).lock('FOR UPDATE NOWAIT').load
        rescue ActiveRecord::LockWaitTimeout
          t.rollback_and_return! ServiceResponse.error(
            message: 'Could not acquire lock on modules',
            error_code: :lock_timeout
          )
        end

        def build_definition_update_service(service, definitions, runtime_module)
          service.new(
            current_runtime,
            definitions,
            runtime_module: runtime_module,
            update_runtime_compatibility: false
          )
        end

        def update_runtime_compatibility
          current_runtime.project_assignments.find_each do |assignment|
            response = Runtimes::CheckRuntimeCompatibilityService.new(
              assignment.runtime,
              assignment.namespace_project
            ).execute

            assignment.update!(compatible: response.success?)
          end
        end
      end
    end
  end
end
