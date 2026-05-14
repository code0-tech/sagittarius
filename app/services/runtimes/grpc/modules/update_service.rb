# frozen_string_literal: true

module Runtimes
  module Grpc
    module Modules
      class UpdateService
        include Sagittarius::Database::Transactional
        include Code0::ZeroTrack::Loggable
        include Runtimes::Grpc::TranslationUpdateHelper
        include Runtimes::Grpc::DataTypeHelper

        attr_reader :current_runtime, :modules

        def initialize(current_runtime, modules)
          @current_runtime = current_runtime
          @modules = modules
        end

        def execute
          transactional do |t|
            mark_existing_definitions_as_removed

            module_records = update_modules(t)
            next module_records unless module_records.success?

            update_definition_data_types(module_records.payload, t)
            update_configurations(module_records.payload, t)
            update_runtime_flow_types(module_records.payload, t)
            update_flow_types(module_records.payload, t)
            update_runtime_function_definitions(module_records.payload, t)
            update_function_definitions(module_records.payload, t)

            UpdateRuntimeCompatibilityJob.perform_later({ runtime_id: current_runtime.id })

            logger.info(message: 'Updated modules for runtime', runtime_id: current_runtime.id)

            ServiceResponse.success(message: 'Updated modules', payload: modules)
          end
        end

        protected

        def mark_existing_definitions_as_removed
          # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, validations are irrelevant
          DataType.where(runtime: current_runtime).update_all(removed_at: Time.zone.now)
          RuntimeFlowType.where(runtime: current_runtime).update_all(removed_at: Time.zone.now)
          FlowType.where(runtime: current_runtime).update_all(removed_at: Time.zone.now)
          RuntimeFunctionDefinition.where(runtime: current_runtime).update_all(removed_at: Time.zone.now)
          # rubocop:enable Rails/SkipsModelValidations
        end

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

        def update_definition_data_types(module_records, t)
          data_type_links_to_update = []

          modules.each do |grpc_module|
            runtime_module = module_records.fetch(grpc_module)
            grpc_module.definition_data_types.each do |data_type|
              db_data_type = update_datatype(data_type, runtime_module)
              if db_data_type.persisted?
                data_type_links_to_update << [db_data_type, data_type.linked_data_type_identifiers]
                next
              end

              logger.error(message: 'Failed to update data type',
                           runtime_id: current_runtime.id,
                           module_identifier: runtime_module.identifier,
                           data_type_identifier: data_type.identifier,
                           errors: db_data_type.errors.full_messages)

              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update data type',
                                                           error_code: :invalid_data_type,
                                                           details: db_data_type.errors)
            end
          end

          data_type_links_to_update.each do |db_data_type, linked_data_type_identifiers|
            link_data_types(db_data_type, linked_data_type_identifiers, t)
          end
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

        def update_flow_types(module_records, t)
          modules.each do |grpc_module|
            runtime_module = module_records.fetch(grpc_module)
            grpc_module.flow_types.each do |flow_type|
              db_flow_type = update_flowtype(flow_type, runtime_module, t)
              next if db_flow_type.persisted?

              logger.error(message: 'Failed to update flow type',
                           runtime_id: current_runtime.id,
                           module_identifier: runtime_module.identifier,
                           flow_type_identifier: flow_type.identifier,
                           errors: db_flow_type.errors.full_messages)

              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update flow type',
                                                           error_code: :invalid_flow_type,
                                                           details: db_flow_type.errors)
            end
          end
        end

        def update_runtime_flow_types(module_records, t)
          modules.each do |grpc_module|
            runtime_module = module_records.fetch(grpc_module)
            grpc_module.runtime_flow_types.each do |runtime_flow_type|
              db_runtime_flow_type = update_runtime_flowtype(runtime_flow_type, runtime_module, t)
              next if db_runtime_flow_type.persisted?

              logger.error(message: 'Failed to update runtime flow type',
                           runtime_id: current_runtime.id,
                           module_identifier: runtime_module.identifier,
                           runtime_flow_type_identifier: runtime_flow_type.identifier,
                           errors: db_runtime_flow_type.errors.full_messages)

              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update runtime flow type',
                                                           error_code: :invalid_flow_type,
                                                           details: db_runtime_flow_type.errors)
            end
          end
        end

        def update_runtime_function_definitions(module_records, t)
          modules.each do |grpc_module|
            runtime_module = module_records.fetch(grpc_module)
            grpc_module.runtime_function_definitions.each do |runtime_function_definition|
              response = update_runtime_function_definition(runtime_function_definition, runtime_module, t)
              next if response.persisted?

              logger.error(message: 'Failed to update runtime function definition',
                           runtime_id: current_runtime.id,
                           module_identifier: runtime_module.identifier,
                           definition_identifier: runtime_function_definition.runtime_name,
                           errors: response.errors.full_messages)

              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update runtime function definition',
                                                           error_code: :invalid_runtime_function_definition,
                                                           details: response.errors)
            end
          end
        end

        def update_function_definitions(module_records, t)
          modules.each do |grpc_module|
            runtime_module = module_records.fetch(grpc_module)
            grpc_module.function_definitions.each do |function_definition|
              db_function_definition = update_function_definition(function_definition, t)
              next if db_function_definition.persisted?

              logger.error(message: 'Failed to update function definition',
                           runtime_id: current_runtime.id,
                           module_identifier: runtime_module.identifier,
                           definition_identifier: function_definition.runtime_definition_name,
                           errors: db_function_definition.errors.full_messages)

              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update function definition',
                                                           error_code: :invalid_function_definition,
                                                           details: db_function_definition.errors)
            end
          end
        end

        def update_datatype(data_type, runtime_module)
          db_object = DataType.find_or_initialize_by(runtime: current_runtime, identifier: data_type.identifier)
          db_object.runtime_module = runtime_module
          db_object.removed_at = nil
          db_object.type = data_type.type
          db_object.rules = update_rules(data_type.rules, db_object)
          db_object.names = update_translations(data_type.name, db_object.names)
          db_object.aliases = update_translations(data_type.alias, db_object.aliases)
          db_object.display_messages = update_translations(data_type.display_message, db_object.display_messages)
          db_object.generic_keys = data_type.generic_keys.to_a
          db_object.version = data_type.version
          db_object.definition_source = data_type.definition_source
          db_object.save
          db_object
        end

        def update_rules(rules, data_type)
          db_rules = data_type.rules.first(rules.length)
          rules.each_with_index do |rule, index|
            db_rules[index] ||= DataTypeRule.new
            db_rules[index].assign_attributes(
              variant: rule.config,
              config: rule.public_send(rule.config).to_h
            )
          end

          db_rules
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

        def update_runtime_flowtype(runtime_flow_type, runtime_module, t)
          db_object = RuntimeFlowType.find_or_initialize_by(
            runtime: current_runtime,
            identifier: runtime_flow_type.identifier
          )
          db_object.runtime_module = runtime_module
          db_object.removed_at = nil
          db_object.signature = runtime_flow_type.signature
          db_object.editable = runtime_flow_type.editable
          db_object.descriptions = update_translations(runtime_flow_type.description, db_object.descriptions)
          db_object.names = update_translations(runtime_flow_type.name, db_object.names)
          db_object.documentations = update_translations(runtime_flow_type.documentation, db_object.documentations)
          db_object.display_messages = update_translations(runtime_flow_type.display_message,
                                                           db_object.display_messages)
          db_object.aliases = update_translations(runtime_flow_type.alias, db_object.aliases)
          db_object.version = runtime_flow_type.version
          db_object.definition_source = runtime_flow_type.definition_source
          db_object.display_icon = runtime_flow_type.display_icon
          db_object.save
          if db_object.persisted?
            update_settings(runtime_flow_type.runtime_settings, db_object.runtime_flow_type_settings, t)
            link_data_types(db_object, runtime_flow_type.linked_data_type_identifiers, t)
            db_object.save
            ensure_flow_type_for_runtime_flow_type(db_object, runtime_flow_type, t)
          end
          db_object
        end

        def update_flowtype(flow_type, runtime_module, t)
          db_object = FlowType.find_or_initialize_by(runtime: current_runtime, identifier: flow_type.identifier)
          db_object.runtime_flow_type = find_runtime_flow_type(flow_type, t)
          db_object.runtime_module = runtime_module
          db_object.removed_at = nil
          db_object.signature = flow_type.signature
          db_object.editable = flow_type.editable
          db_object.descriptions = update_translations(flow_type.description, db_object.descriptions)
          db_object.names = update_translations(flow_type.name, db_object.names)
          db_object.documentations = update_translations(flow_type.documentation, db_object.documentations)
          db_object.display_messages = update_translations(flow_type.display_message, db_object.display_messages)
          db_object.aliases = update_translations(flow_type.alias, db_object.aliases)
          db_object.version = flow_type.version
          db_object.definition_source = flow_type.definition_source
          db_object.display_icon = flow_type.display_icon
          db_object.save
          if db_object.persisted?
            update_settings(flow_type.settings, db_object.flow_type_settings, t)
            link_data_types(db_object, flow_type.linked_data_type_identifiers, t)
            db_object.save
          end
          db_object
        end

        def ensure_flow_type_for_runtime_flow_type(runtime_flow_type, grpc_runtime_flow_type, t)
          return if runtime_flow_type.flow_types.exists?

          flow_type = runtime_flow_type.flow_types.build(
            runtime: current_runtime,
            runtime_module: runtime_flow_type.runtime_module,
            identifier: runtime_flow_type.identifier,
            signature: runtime_flow_type.signature,
            editable: runtime_flow_type.editable,
            version: runtime_flow_type.version,
            definition_source: runtime_flow_type.definition_source,
            display_icon: runtime_flow_type.display_icon,
            removed_at: nil
          )
          flow_type.names = update_translations(grpc_runtime_flow_type.name, flow_type.names)
          flow_type.descriptions = update_translations(grpc_runtime_flow_type.description, flow_type.descriptions)
          flow_type.documentations = update_translations(grpc_runtime_flow_type.documentation, flow_type.documentations)
          flow_type.display_messages = update_translations(grpc_runtime_flow_type.display_message,
                                                           flow_type.display_messages)
          flow_type.aliases = update_translations(grpc_runtime_flow_type.alias, flow_type.aliases)
          flow_type.save
          return unless flow_type.persisted?

          update_settings(grpc_runtime_flow_type.runtime_settings, flow_type.flow_type_settings, t)
          link_data_types(flow_type, grpc_runtime_flow_type.linked_data_type_identifiers, t)
          flow_type.save
        end

        def find_runtime_flow_type(flow_type, t)
          identifier = flow_type.runtime_identifier.presence || flow_type.identifier
          runtime_flow_type = RuntimeFlowType.find_by(runtime: current_runtime, identifier: identifier)
          return runtime_flow_type if runtime_flow_type.present?

          t.rollback_and_return! ServiceResponse.error(
            message: "Could not find runtime flow type with identifier #{identifier}",
            error_code: :invalid_flow_type
          )
        end

        def update_settings(flow_type_settings, db_setting_relation, t)
          # rubocop:disable Rails/SkipsModelValidations -- when marking settings as removed, validations are irrelevant
          db_setting_relation.update_all(removed_at: Time.zone.now)
          # rubocop:enable Rails/SkipsModelValidations

          flow_type_settings.each do |setting|
            db_setting = db_setting_relation.find_or_initialize_by(identifier: setting.identifier)
            db_setting.unique = setting.unique&.to_s&.downcase
            db_setting.default_value = setting.default_value&.to_ruby
            db_setting.descriptions = update_translations(setting.description, db_setting.descriptions)
            db_setting.names = update_translations(setting.name, db_setting.names)
            db_setting.removed_at = nil
            next if db_setting.save

            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to update flow type setting',
              error_code: :invalid_flow_setting,
              details: db_setting.errors
            )
          end
        end

        def update_runtime_function_definition(runtime_function_definition, runtime_module, t)
          db_object = RuntimeFunctionDefinition.find_or_initialize_by(
            runtime: current_runtime,
            runtime_name: runtime_function_definition.runtime_name
          )
          db_object.runtime_module = runtime_module
          db_object.removed_at = nil
          db_object.signature = runtime_function_definition.signature
          db_object.throws_error = runtime_function_definition.throws_error
          db_object.version = runtime_function_definition.version
          db_object.definition_source = runtime_function_definition.definition_source
          db_object.display_icon = runtime_function_definition.display_icon
          db_object.names = update_translations(runtime_function_definition.name, db_object.names)
          db_object.descriptions = update_translations(runtime_function_definition.description, db_object.descriptions)
          db_object.documentations = update_translations(runtime_function_definition.documentation,
                                                         db_object.documentations)
          db_object.deprecation_messages = update_translations(runtime_function_definition.deprecation_message,
                                                               db_object.deprecation_messages)
          db_object.display_messages = update_translations(runtime_function_definition.display_message,
                                                           db_object.display_messages)
          db_object.aliases = update_translations(runtime_function_definition.alias, db_object.aliases)

          db_object.save

          if db_object.function_definitions.empty?
            definition = FunctionDefinition.new
            definition.names = update_translations(runtime_function_definition.name, definition.names)
            definition.descriptions = update_translations(runtime_function_definition.description,
                                                          definition.descriptions)
            definition.documentations = update_translations(runtime_function_definition.documentation,
                                                            definition.documentations)
            definition.display_messages = update_translations(runtime_function_definition.display_message,
                                                              definition.display_messages)
            definition.aliases = update_translations(runtime_function_definition.alias, definition.aliases)

            db_object.function_definitions << definition
          end

          db_object.parameters = update_parameters(db_object, runtime_function_definition.runtime_parameter_definitions,
                                                   db_object.parameters, t)

          link_data_types(db_object, runtime_function_definition.linked_data_type_identifiers, t)
          db_object
        end

        def update_function_definition(function_definition, t)
          runtime_definition_name = function_definition.runtime_definition_name.presence ||
                                    function_definition.runtime_name
          runtime_function_definition = RuntimeFunctionDefinition.find_by(
            runtime: current_runtime,
            runtime_name: runtime_definition_name
          )

          if runtime_function_definition.nil?
            return t.rollback_and_return! ServiceResponse.error(
              message: "Could not find runtime function definition #{runtime_definition_name}",
              error_code: :invalid_runtime_function_definition
            )
          end

          db_object = runtime_function_definition.function_definitions.first_or_initialize
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

        def update_parameters(runtime_function_definition, parameters, db_parameters, t)
          # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, validations are irrelevant
          db_parameters.update_all(removed_at: Time.zone.now)
          # rubocop:enable Rails/SkipsModelValidations

          parameters.each do |real_param|
            db_param = db_parameters.find { |current_param| current_param.runtime_name == real_param.runtime_name }
            if db_param.nil?
              db_param = RuntimeParameterDefinition.new
              db_parameters << db_param
            end
            db_param.runtime_function_definition = runtime_function_definition
            db_param.runtime_name = real_param.runtime_name
            db_param.removed_at = nil

            db_param.names = update_translations(real_param.name, db_param.names)
            db_param.descriptions = update_translations(real_param.description, db_param.descriptions)
            db_param.documentations = update_translations(real_param.documentation, db_param.documentations)

            db_param.default_value = real_param.default_value&.to_ruby(true)

            unless db_param.save
              t.rollback_and_return! ServiceResponse.error(
                message: 'Could not save runtime parameter definition',
                error_code: :invalid_runtime_parameter_definition,
                details: db_param.errors
              )
            end

            next unless db_param.parameter_definitions.empty?

            definition = ParameterDefinition.new
            definition.names = update_translations(real_param.name, definition.names)
            definition.descriptions = update_translations(real_param.description, definition.descriptions)
            definition.documentations = update_translations(real_param.documentation, definition.documentations)
            definition.default_value = db_param.default_value
            definition.function_definition = runtime_function_definition.function_definitions.first

            db_param.parameter_definitions << definition
          end

          db_parameters
        end
      end
    end
  end
end
