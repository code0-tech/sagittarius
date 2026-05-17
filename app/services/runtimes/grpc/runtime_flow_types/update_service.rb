# frozen_string_literal: true

module Runtimes
  module Grpc
    module RuntimeFlowTypes
      class UpdateService
        include Sagittarius::Database::Transactional
        include Code0::ZeroTrack::Loggable
        include Runtimes::Grpc::TranslationUpdateHelper
        include Runtimes::Grpc::DataTypeHelper

        attr_reader :current_runtime, :runtime_flow_types, :runtime_module, :update_runtime_compatibility

        def initialize(current_runtime, runtime_flow_types, runtime_module:, update_runtime_compatibility: true)
          @current_runtime = current_runtime
          @runtime_flow_types = runtime_flow_types
          @runtime_module = runtime_module
          @update_runtime_compatibility = update_runtime_compatibility
        end

        def execute
          transactional do |t|
            # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, validations are irrelevant
            RuntimeFlowType.where(runtime: current_runtime, runtime_module: runtime_module)
                           .update_all(removed_at: Time.zone.now)
            # rubocop:enable Rails/SkipsModelValidations

            runtime_flow_types.each do |runtime_flow_type|
              db_runtime_flow_type = update_runtime_flowtype(runtime_flow_type, t)
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

            enqueue_runtime_compatibility_update

            logger.info(message: 'Updated runtime flow types for runtime',
                        runtime_id: current_runtime.id,
                        module_identifier: runtime_module.identifier)

            ServiceResponse.success(message: 'Updated runtime flow types', payload: runtime_flow_types)
          end
        end

        protected

        def enqueue_runtime_compatibility_update
          return unless update_runtime_compatibility

          UpdateRuntimeCompatibilityJob.perform_later({ runtime_id: current_runtime.id })
        end

        def update_runtime_flowtype(runtime_flow_type, t)
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
          end
          db_object
        end

        def update_settings(flow_type_settings, db_setting_relation, t)
          # rubocop:disable Rails/SkipsModelValidations -- when marking settings as removed, validations are irrelevant
          db_setting_relation.update_all(removed_at: Time.zone.now)
          # rubocop:enable Rails/SkipsModelValidations

          flow_type_settings.each do |setting|
            db_setting = db_setting_relation.find_or_initialize_by(identifier: setting.identifier)
            db_setting.unique = setting.unique&.to_s&.downcase
            db_setting.default_value = setting.default_value&.to_ruby
            db_setting.optional = setting.optional
            db_setting.hidden = setting.hidden
            db_setting.descriptions = update_translations(setting.description, db_setting.descriptions)
            db_setting.names = update_translations(setting.name, db_setting.names)
            db_setting.removed_at = nil
            next if db_setting.save

            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to update runtime flow type setting',
              error_code: :invalid_flow_setting,
              details: db_setting.errors
            )
          end
        end
      end
    end
  end
end
