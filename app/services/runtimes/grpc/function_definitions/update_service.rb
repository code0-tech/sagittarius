# frozen_string_literal: true

module Runtimes
  module Grpc
    module FunctionDefinitions
      class UpdateService
        include Sagittarius::Database::Transactional
        include Code0::ZeroTrack::Loggable
        include Runtimes::Grpc::TranslationUpdateHelper

        attr_reader :current_runtime, :function_definitions, :runtime_module, :update_runtime_compatibility

        def initialize(current_runtime, function_definitions, runtime_module:, update_runtime_compatibility: true)
          @current_runtime = current_runtime
          @function_definitions = function_definitions
          @runtime_module = runtime_module
          @update_runtime_compatibility = update_runtime_compatibility
        end

        def execute
          transactional do |t|
            mark_existing_function_definitions_as_removed

            function_definitions.each do |function_definition|
              update_function_definition(function_definition, t)
            end

            enqueue_runtime_compatibility_update

            logger.info(message: 'Updated function definitions for runtime',
                        runtime_id: current_runtime.id,
                        module_identifier: runtime_module.identifier)

            ServiceResponse.success(message: 'Updated function definitions', payload: function_definitions)
          end
        end

        protected

        def mark_existing_function_definitions_as_removed
          # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, validations are irrelevant
          FunctionDefinition.where(runtime: current_runtime, runtime_module: runtime_module)
                            .update_all(removed_at: Time.zone.now)
          # rubocop:enable Rails/SkipsModelValidations
        end

        def enqueue_runtime_compatibility_update
          return unless update_runtime_compatibility

          UpdateRuntimeCompatibilityJob.perform_later({ runtime_id: current_runtime.id })
        end

        def update_function_definition(function_definition, t)
          runtime_function_definition = find_runtime_function_definition(function_definition, t)

          db_object = FunctionDefinition.find_or_initialize_by(
            runtime: current_runtime,
            identifier: function_definition.runtime_name
          )
          db_object.runtime_module = runtime_module
          db_object.runtime_function_definition = runtime_function_definition
          db_object.removed_at = nil
          db_object.names = update_translations(function_definition.name, db_object.names)
          db_object.descriptions = update_translations(function_definition.description, db_object.descriptions)
          db_object.documentations = update_translations(function_definition.documentation, db_object.documentations)
          db_object.design = function_definition.design
          db_object.deprecation_messages = update_translations(function_definition.deprecation_message,
                                                               db_object.deprecation_messages)
          db_object.display_messages = update_translations(function_definition.display_message,
                                                           db_object.display_messages)
          db_object.aliases = update_translations(function_definition.alias, db_object.aliases)

          unless db_object.save
            logger.error(message: 'Failed to update function definition',
                         module_identifier: runtime_module.identifier,
                         definition_identifier: function_definition.runtime_name,
                         errors: db_object.errors.full_messages)

            t.rollback_and_return! ServiceResponse.error(message: 'Failed to update function definition',
                                                         error_code: :invalid_function_definition,
                                                         details: db_object.errors)
          end

          update_parameter_definitions(db_object, function_definition.parameter_definitions, t)

          db_object
        end

        def find_runtime_function_definition(function_definition, t)
          runtime_definition_name = function_definition.runtime_definition_name.presence ||
                                    function_definition.runtime_name
          runtime_function_definition = RuntimeFunctionDefinition.find_by(
            runtime: current_runtime,
            runtime_name: runtime_definition_name
          )
          return runtime_function_definition if runtime_function_definition.present?

          logger.error(message: 'Could not find runtime function definition',
                       runtime_id: current_runtime.id,
                       runtime_definition_name: runtime_definition_name)

          t.rollback_and_return! ServiceResponse.error(
            message: "Could not find runtime function definition #{runtime_definition_name}",
            error_code: :invalid_runtime_function_definition
          )
        end

        def update_parameter_definitions(function_definition, parameters, t)
          parameters.each do |parameter|
            db_param = update_parameter_definition(function_definition, parameter, t)
            next if db_param.save

            t.rollback_and_return! ServiceResponse.error(
              message: 'Could not save parameter definition',
              error_code: :invalid_parameter_definition,
              details: db_param.errors
            )
          end
        end

        def update_parameter_definition(function_definition, parameter, t)
          runtime_parameter_definition = find_runtime_parameter_definition(function_definition, parameter, t)
          db_param = runtime_parameter_definition.parameter_definitions.find_or_initialize_by(
            function_definition: function_definition
          )
          db_param.default_value = parameter.default_value&.to_ruby(true)
          db_param.optional = parameter.optional
          db_param.hidden = parameter.hidden
          db_param.names = update_translations(parameter.name, db_param.names)
          db_param.descriptions = update_translations(parameter.description, db_param.descriptions)
          db_param.documentations = update_translations(parameter.documentation, db_param.documentations)
          db_param
        end

        def find_runtime_parameter_definition(function_definition, parameter, t)
          runtime_name = parameter.runtime_definition_name.presence || parameter.runtime_name
          runtime_parameter_definition = function_definition.runtime_function_definition.parameters.find_by(
            runtime_name: runtime_name
          )
          return runtime_parameter_definition if runtime_parameter_definition.present?

          logger.error(message: 'Could not find runtime parameter definition',
                       runtime_id: current_runtime.id,
                       function_definition_id: function_definition.id,
                       runtime_definition_name: runtime_name)

          t.rollback_and_return! ServiceResponse.error(
            message: "Could not find runtime parameter definition #{runtime_name}",
            error_code: :invalid_runtime_parameter_definition
          )
        end
      end
    end
  end
end
