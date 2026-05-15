# frozen_string_literal: true

module Runtimes
  module Grpc
    module Modules
      class UpdateService
        include Sagittarius::Database::Transactional
        include Code0::ZeroTrack::Loggable
        include Runtimes::Grpc::TranslationUpdateHelper
        include Runtimes::Grpc::DataTypeHelper

        DEFAULT_DEFINITION_UPDATE_SERVICES = {
          runtime_flow_types: Runtimes::Grpc::RuntimeFlowTypes::UpdateService,
          flow_types: Runtimes::Grpc::FlowTypes::UpdateService,
          runtime_function_definitions: Runtimes::Grpc::RuntimeFunctionDefinitions::UpdateService,
        }.freeze

        attr_reader :current_runtime, :modules, :definition_update_services

        def initialize(current_runtime, modules, definition_update_services: DEFAULT_DEFINITION_UPDATE_SERVICES)
          @current_runtime = current_runtime
          @modules = modules
          @definition_update_services = definition_update_services
        end

        def execute
          transactional do |t|
            module_records = update_modules(t)
            next module_records unless module_records.success?

            update_data_types(module_records.payload, t)
            update_definition_services(module_records.payload, t)
            update_configurations(module_records.payload, t)
            update_function_definitions(module_records.payload, t)

            UpdateRuntimeCompatibilityJob.perform_later({ runtime_id: current_runtime.id })

            logger.info(message: 'Updated modules for runtime', runtime_id: current_runtime.id)

            ServiceResponse.success(message: 'Updated modules', payload: modules)
          end
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
            module_record.version = grpc_module.version.presence || '0.0.0'
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

        def build_definition_update_service(service, definitions, runtime_module)
          service.new(
            current_runtime,
            definitions,
            runtime_module: runtime_module,
            update_runtime_compatibility: false
          )
        end

        def update_configurations(module_records, t)
          modules.each do |grpc_module|
            runtime_module = module_records.fetch(grpc_module)
            grpc_module.configurations.each do |configuration|
              db_configuration = update_configuration(configuration, runtime_module, t)
              next if db_configuration.persisted?

              logger.error(message: 'Failed to update module configuration definition',
                           runtime_id: current_runtime.id,
                           module_identifier: runtime_module.identifier,
                           configuration_identifier: configuration.identifier,
                           errors: db_configuration.errors.full_messages)

              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update module configuration definition',
                                                           error_code: :invalid_module_configuration_definition,
                                                           details: db_configuration.errors)
            end
          end
        end

        def update_function_definitions(module_records, t)
          modules.each do |grpc_module|
            runtime_module = module_records.fetch(grpc_module)

            # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, validations are irrelevant
            FunctionDefinition.where(runtime_module: runtime_module).update_all(removed_at: Time.zone.now)
            # rubocop:enable Rails/SkipsModelValidations

            grpc_module.function_definitions.each do |function_definition|
              db_function_definition = update_function_definition(function_definition, runtime_module, t)
              next if db_function_definition.persisted?

              logger.error(message: 'Failed to update function definition',
                           runtime_id: current_runtime.id,
                           module_identifier: runtime_module.identifier,
                           definition_identifier: function_definition.runtime_name,
                           errors: db_function_definition.errors.full_messages)

              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update function definition',
                                                           error_code: :invalid_function_definition,
                                                           details: db_function_definition.errors)
            end
          end
        end

        def update_configuration(configuration, runtime_module, t)
          db_object = runtime_module.module_configuration_definitions.find_or_initialize_by(
            identifier: configuration.identifier
          )
          db_object.type = configuration.type
          db_object.default_value = configuration.default_value&.to_ruby(true)
          db_object.optional = configuration.optional
          db_object.hidden = configuration.hidden
          db_object.names = update_translations(configuration.name, db_object.names)
          db_object.descriptions = update_translations(configuration.description, db_object.descriptions)
          db_object.save
          link_data_types(db_object, configuration.linked_data_type_identifiers, t) if db_object.persisted?
          db_object
        end

        def update_function_definition(function_definition, runtime_module, t)
          runtime_definition_name = function_definition.runtime_definition_name.presence ||
                                    function_definition.runtime_name
          runtime_function_definition = RuntimeFunctionDefinition.find_by(
            runtime: current_runtime,
            runtime_name: runtime_definition_name
          )

          if runtime_function_definition.nil?
            logger.error(message: 'Could not find runtime function definition',
                         runtime_id: current_runtime.id,
                         runtime_definition_name: runtime_definition_name)

            return t.rollback_and_return! ServiceResponse.error(
              message: "Could not find runtime function definition #{runtime_definition_name}",
              error_code: :invalid_runtime_function_definition
            )
          end

          db_object = runtime_module.function_definitions.find_or_initialize_by(
            identifier: function_definition.runtime_name
          )
          db_object.runtime_function_definition = runtime_function_definition
          db_object.removed_at = nil
          db_object.names = update_translations(function_definition.name, db_object.names)
          db_object.descriptions = update_translations(function_definition.description, db_object.descriptions)
          db_object.documentations = update_translations(function_definition.documentation, db_object.documentations)
          db_object.deprecation_messages = update_translations(function_definition.deprecation_message,
                                                               db_object.deprecation_messages)
          db_object.display_messages = update_translations(function_definition.display_message,
                                                           db_object.display_messages)
          db_object.aliases = update_translations(function_definition.alias, db_object.aliases)
          db_object.save

          update_parameter_definitions(db_object, function_definition.parameter_definitions, t) if db_object.persisted?

          db_object
        end

        def update_parameter_definitions(function_definition, parameters, t)
          parameters.each do |parameter|
            runtime_name = parameter.runtime_definition_name.presence || parameter.runtime_name
            runtime_parameter_definition = function_definition.runtime_function_definition.parameters.find_by(
              runtime_name: runtime_name
            )

            if runtime_parameter_definition.nil?
              logger.error(message: 'Could not find runtime parameter definition',
                           runtime_id: current_runtime.id,
                           function_definition_id: function_definition.id,
                           runtime_definition_name: runtime_name)

              t.rollback_and_return! ServiceResponse.error(
                message: "Could not find runtime parameter definition #{runtime_name}",
                error_code: :invalid_runtime_parameter_definition
              )
            end

            db_param = runtime_parameter_definition.parameter_definitions.find_or_initialize_by(
              function_definition: function_definition
            )
            db_param.default_value = parameter.default_value&.to_ruby(true)
            db_param.names = update_translations(parameter.name, db_param.names)
            db_param.descriptions = update_translations(parameter.description, db_param.descriptions)
            db_param.documentations = update_translations(parameter.documentation, db_param.documentations)
            if db_param.save
              db_param.names.each(&:save!)
              db_param.descriptions.each(&:save!)
              db_param.documentations.each(&:save!)
              next
            end

            t.rollback_and_return! ServiceResponse.error(
              message: 'Could not save parameter definition',
              error_code: :invalid_parameter_definition,
              details: db_param.errors
            )
          end
        end
      end
    end
  end
end
