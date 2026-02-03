# frozen_string_literal: true

module Runtimes
  module Grpc
    module RuntimeFunctionDefinitions
      class UpdateService
        include Sagittarius::Database::Transactional
        include Code0::ZeroTrack::Loggable
        include Runtimes::Grpc::TranslationUpdateHelper
        include Runtimes::Grpc::DataTypeHelper

        attr_reader :current_runtime, :runtime_function_definitions

        def initialize(current_runtime, runtime_function_definitions)
          @current_runtime = current_runtime
          @runtime_function_definitions = runtime_function_definitions
        end

        def execute
          transactional do |t|
            # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, we don't care about validations
            RuntimeFunctionDefinition.where(runtime: current_runtime).update_all(removed_at: Time.zone.now)
            # rubocop:enable Rails/SkipsModelValidations
            runtime_function_definitions.each do |runtime_function_definition|
              response = update_runtime_function_definition(runtime_function_definition, t)
              next if response.persisted?

              logger.error(message: 'Failed to update runtime function definition',
                           runtime_id: current_runtime.id,
                           definition_identifier: runtime_function_definition.identifier,
                           errors: response.errors.full_messages)

              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update runtime function definition',
                                                           error_code: :invalid_runtime_function_definition,
                                                           details: response.errors)
            end

            UpdateRuntimeCompatibilityJob.perform_later({ runtime_id: current_runtime.id })

            logger.info(message: 'Updated runtime function definitions for runtime', runtime_id: current_runtime.id)

            ServiceResponse.success(message: 'Updated runtime function definition',
                                    payload: runtime_function_definitions)
          end
        end

        protected

        def update_runtime_function_definition(runtime_function_definition, t)
          db_object = RuntimeFunctionDefinition.find_or_initialize_by(
            runtime: current_runtime,
            runtime_name: runtime_function_definition.runtime_name
          )
          db_object.removed_at = nil
          db_object.return_type = if runtime_function_definition.return_type_identifier.present?
                                    find_data_type_identifier(
                                      runtime_function_definition.return_type_identifier,
                                      db_object,
                                      t
                                    )
                                  end
          db_object.names = update_translations(runtime_function_definition.name, db_object.names)
          db_object.descriptions = update_translations(runtime_function_definition.description, db_object.descriptions)
          db_object.documentations = update_translations(runtime_function_definition.documentation,
                                                         db_object.documentations)
          db_object.deprecation_messages = update_translations(runtime_function_definition.deprecation_message,
                                                               db_object.deprecation_messages)
          db_object.display_messages = update_translations(runtime_function_definition.display_message,
                                                           db_object.display_messages)
          db_object.aliases = update_translations(runtime_function_definition.alias, db_object.aliases)

          db_object.generic_keys = runtime_function_definition.generic_keys.to_a

          db_object.throws_error = runtime_function_definition.throws_error
          db_object.version = runtime_function_definition.version

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
            definition.return_type = db_object.return_type

            db_object.function_definitions << definition
          end

          db_object.parameters = update_parameters(db_object, runtime_function_definition.runtime_parameter_definitions,
                                                   db_object.parameters, t)

          db_object.save
          db_object
        end

        def update_parameters(runtime_function_definition, parameters, db_parameters, t)
          # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, we don't care about validations
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
            db_param.data_type = find_data_type_identifier(real_param.data_type_identifier, db_param, t)

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
            definition.data_type = db_param.data_type
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
