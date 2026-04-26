# frozen_string_literal: true

module Runtimes
  module Grpc
    module FunctionDefinitions
      class UpdateService
        include Sagittarius::Database::Transactional
        include Code0::ZeroTrack::Loggable
        include Runtimes::Grpc::TranslationUpdateHelper
        include Runtimes::Grpc::DataTypeHelper

        attr_reader :current_runtime, :function_definitions

        def initialize(current_runtime, function_definitions)
          @current_runtime = current_runtime
          @function_definitions = function_definitions
        end

        def execute
          transactional do |t|
            # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, we don't care about validations
            FunctionDefinition
              .joins(:runtime)
              .where(runtimes: { id: current_runtime })
              .update_all(removed_at: Time.zone.now)
            # rubocop:enable Rails/SkipsModelValidations
            function_definitions.each do |function_definition|
              response = update_function_definition(function_definition, t)
              next if response.persisted?

              logger.error(message: 'Failed to update function definition',
                           runtime_id: current_runtime.id,
                           definition_identifier: function_definition.runtime_name,
                           errors: response.errors.full_messages)

              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update function definition',
                                                           error_code: :invalid_function_definition,
                                                           details: response.errors)
            end

            UpdateRuntimeCompatibilityJob.perform_later({ runtime_id: current_runtime.id })

            logger.info(message: 'Updated function definitions for runtime', runtime_id: current_runtime.id)

            ServiceResponse.success(message: 'Updated function definition',
                                    payload: function_definitions)
          end
        end

        protected

        def update_function_definition(function_definition, t)
          parent_runtime_function_definition = RuntimeFunctionDefinition.find_by(
            runtime: current_runtime,
            runtime_name: function_definition.runtime_definition_name
          )
          if parent_runtime_function_definition.nil?
            t.rollback_and_return! ServiceResponse.error(
              message: 'Could not find parent runtime function definition for function definition',
              error_code: :parent_runtime_function_definition_not_found,
              details: { runtime_definition_name: function_definition.runtime_definition_name }
            )
          end

          db_object = FunctionDefinition.find_or_initialize_by(
            runtime_function_definition_id: parent_runtime_function_definition.id,
            runtime_name: function_definition.runtime_name,
            runtime_definition_name: function_definition.runtime_definition_name
          )
          db_object.runtime_function_definition = parent_runtime_function_definition
          db_object.removed_at = nil
          db_object.signature = function_definition.signature
          db_object.throws_error = function_definition.throws_error
          db_object.version = function_definition.version
          db_object.definition_source = function_definition.definition_source
          db_object.display_icon = function_definition.display_icon
          db_object.names = update_translations(function_definition.name, db_object.names)
          db_object.descriptions = update_translations(function_definition.description, db_object.descriptions)
          db_object.documentations = update_translations(function_definition.documentation, db_object.documentations)
          db_object.deprecation_messages = update_translations(function_definition.deprecation_message,
                                                               db_object.deprecation_messages)
          db_object.display_messages = update_translations(function_definition.display_message,
                                                           db_object.display_messages)
          db_object.aliases = update_translations(function_definition.alias, db_object.aliases)

          db_object.save

          db_object.parameter_definitions = update_parameters(db_object, function_definition.parameter_definitions,
                                                              db_object.parameter_definitions, t)

          link_data_types(db_object, function_definition.linked_data_type_identifiers, t)
          db_object
        end

        def update_parameters(function_definition, parameters, db_parameters, t)
          # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, we don't care about validations
          db_parameters.update_all(removed_at: Time.zone.now)
          # rubocop:enable Rails/SkipsModelValidations

          parameters.each do |real_param|
            db_param = db_parameters.find do |current_param|
              current_param.runtime_definition_name == real_param.runtime_definition_name
            end
            if db_param.nil?
              db_param = ParameterDefinition.new
              db_parameters << db_param
            end

            runtime_parameter_definition = RuntimeParameterDefinition.find_by(
              runtime_function_definition_id: function_definition.runtime_function_definition_id,
              runtime_name: real_param.runtime_definition_name
            )
            if runtime_parameter_definition.nil?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Could not find parent runtime parameter definition for function definition parameter',
                error_code: :parent_runtime_parameter_definition_not_found,
                details: { runtime_definition_name: real_param.runtime_definition_name }
              )
            end

            db_param.function_definition = function_definition
            db_param.runtime_parameter_definition = runtime_parameter_definition
            db_param.runtime_name = real_param.runtime_name
            db_param.runtime_definition_name = real_param.runtime_definition_name
            db_param.removed_at = nil

            db_param.names = update_translations(real_param.name, db_param.names)
            db_param.descriptions = update_translations(real_param.description, db_param.descriptions)
            db_param.documentations = update_translations(real_param.documentation, db_param.documentations)

            db_param.default_value = real_param.default_value&.to_ruby(true)

            next if db_param.save

            t.rollback_and_return! ServiceResponse.error(
              message: 'Could not save parameter definition',
              error_code: :invalid_parameter_definition,
              details: db_param.errors
            )
          end

          if db_parameters.reload.where(removed_at: nil).count !=
             function_definition.runtime_function_definition.parameters.size
            t.rollback_and_return! ServiceResponse.error(
              message: 'Number of parameter definitions does not match number of runtime parameter definitions',
              error_code: :parameter_definition_count_mismatch
            )
          end
          db_parameters
        end
      end
    end
  end
end
