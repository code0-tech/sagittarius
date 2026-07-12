# frozen_string_literal: true

module Runtimes
  module Grpc
    module ModuleConfigurationDefinitions
      class UpdateService
        include Sagittarius::Database::Transactional
        include Code0::ZeroTrack::Loggable
        include Runtimes::Grpc::TranslationUpdateHelper
        include Runtimes::Grpc::DataTypeHelper

        attr_reader :current_runtime, :configuration_definitions, :runtime_module, :update_runtime_compatibility

        def initialize(current_runtime, configuration_definitions, runtime_module:, update_runtime_compatibility: true)
          @current_runtime = current_runtime
          @configuration_definitions = configuration_definitions
          @runtime_module = runtime_module
          @update_runtime_compatibility = update_runtime_compatibility
        end

        def execute
          transactional do |t|
            configuration_definitions.each do |configuration_definition|
              update_configuration(configuration_definition, t)
            end

            enqueue_runtime_compatibility_update

            logger.info(message: 'Updated module configuration definitions for runtime',
                        runtime_id: current_runtime.id,
                        module_identifier: runtime_module.identifier)

            ServiceResponse.success(message: 'Updated module configuration definitions',
                                    payload: configuration_definitions)
          end
        end

        protected

        def enqueue_runtime_compatibility_update
          return unless update_runtime_compatibility

          UpdateRuntimeCompatibilityJob.perform_later({ runtime_id: current_runtime.id })
        end

        def update_configuration(configuration, t)
          db_object = runtime_module.module_configuration_definitions.find_or_initialize_by(
            identifier: configuration.identifier
          )
          db_object.type = configuration.type
          db_object.default_value = configuration.default_value&.to_ruby(true)
          db_object.optional = configuration.optional
          db_object.hidden = configuration.hidden
          db_object.names = update_translations(configuration.name, db_object.names)
          db_object.descriptions = update_translations(configuration.description, db_object.descriptions)

          unless db_object.save
            logger.error(message: 'Failed to update module configuration definition',
                         module_identifier: runtime_module.identifier,
                         configuration_identifier: configuration.identifier,
                         errors: db_object.errors.full_messages)

            t.rollback_and_return! ServiceResponse.error(message: 'Failed to update module configuration definition',
                                                         error_code: :invalid_module_configuration_definition,
                                                         details: db_object.errors)
          end

          link_data_types(db_object, configuration.linked_data_type_identifiers, t) if db_object.persisted?
          db_object
        end
      end
    end
  end
end
