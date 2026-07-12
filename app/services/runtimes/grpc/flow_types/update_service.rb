# frozen_string_literal: true

module Runtimes
  module Grpc
    module FlowTypes
      class UpdateService
        include Sagittarius::Database::Transactional
        include Code0::ZeroTrack::Loggable
        include Runtimes::Grpc::TranslationUpdateHelper
        include Runtimes::Grpc::DataTypeHelper

        attr_reader :current_runtime, :flow_types, :runtime_module, :update_runtime_compatibility

        def initialize(current_runtime, flow_types, runtime_module:, update_runtime_compatibility: true)
          @current_runtime = current_runtime
          @flow_types = flow_types
          @runtime_module = runtime_module
          @update_runtime_compatibility = update_runtime_compatibility
        end

        def execute
          transactional do |t|
            # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, we don't care about validations
            FlowType.where(runtime: current_runtime, runtime_module: runtime_module)
                    .update_all(removed_at: Time.zone.now)
            # rubocop:enable Rails/SkipsModelValidations
            flow_types.each do |flow_type|
              update_flowtype(flow_type, t)
            end

            enqueue_runtime_compatibility_update

            logger.info(message: 'Updated flow types for runtime', runtime_id: current_runtime.id)

            ServiceResponse.success(message: 'Updated data types', payload: flow_types)
          end
        end

        protected

        def enqueue_runtime_compatibility_update
          return unless update_runtime_compatibility

          UpdateRuntimeCompatibilityJob.perform_later({ runtime_id: current_runtime.id })
        end

        def update_flowtype(flow_type, t)
          db_object = FlowType.find_or_initialize_by(runtime: current_runtime, identifier: flow_type.identifier)
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
          db_object.runtime_module = runtime_module
          db_object.runtime_flow_type = find_runtime_flow_type(flow_type, t)
          update_settings(flow_type.settings, db_object.flow_type_settings, t)
          link_data_types(db_object, flow_type.linked_data_type_identifiers, t)

          unless db_object.save
            logger.error(
              message: 'Failed to update flow type',
              module_identifier: runtime_module.identifier,
              flow_type_identifier: flow_type.identifier,
              errors: db_object.errors.full_messages
            )

            t.rollback_and_return! ServiceResponse.error(message: 'Failed to update flow type',
                                                         error_code: :invalid_flow_type,
                                                         details: db_object.errors)
          end

          db_object
        end

        def find_runtime_flow_type(flow_type, t)
          identifier = flow_type.runtime_identifier.presence || flow_type.identifier
          runtime_flow_type = RuntimeFlowType.find_by(
            runtime: current_runtime,
            identifier: identifier
          )
          return runtime_flow_type if runtime_flow_type.present?

          t.rollback_and_return! ServiceResponse.error(
            message: "Could not find runtime flow type with identifier #{identifier}",
            error_code: :invalid_flow_type
          )
        end

        def update_settings(flow_type_settings, db_setting_relation, t)
          # rubocop:disable Rails/SkipsModelValidations -- when marking settings as removed, we don't care about validations
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
              message: 'Failed to update flow type setting',
              error_code: :invalid_flow_setting,
              details: db_setting.errors
            )
          end
        end
      end
    end
  end
end
