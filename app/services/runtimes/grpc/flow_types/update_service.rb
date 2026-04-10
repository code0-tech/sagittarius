# frozen_string_literal: true

module Runtimes
  module Grpc
    module FlowTypes
      class UpdateService
        include Sagittarius::Database::Transactional
        include Code0::ZeroTrack::Loggable
        include Runtimes::Grpc::TranslationUpdateHelper
        include Runtimes::Grpc::DataTypeHelper

        attr_reader :current_runtime, :flow_types

        def initialize(current_runtime, flow_types)
          @current_runtime = current_runtime
          @flow_types = flow_types
        end

        def execute
          transactional do |t|
            # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, we don't care about validations
            FlowType.where(runtime: current_runtime).update_all(removed_at: Time.zone.now)
            # rubocop:enable Rails/SkipsModelValidations
            flow_types.each do |flow_type|
              db_flow_type = update_flowtype(flow_type, t)
              next if db_flow_type.persisted?

              logger.error(
                message: 'Failed to update flow type',
                runtime_id: current_runtime.id,
                flow_type_identifier: flow_type.identifier,
                errors: db_flow_type.errors.full_messages
              )

              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update flow type',
                                                           error_code: :invalid_flow_type,
                                                           details: db_flow_type.errors)
            end

            UpdateRuntimeCompatibilityJob.perform_later({ runtime_id: current_runtime.id })

            logger.info(message: 'Updated flow types for runtime', runtime_id: current_runtime.id)

            ServiceResponse.success(message: 'Updated data types', payload: flow_types)
          end
        end

        protected

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
          db_object.flow_type_settings = update_settings(flow_type.settings, db_object.flow_type_settings)
          link_data_types(db_object, flow_type.linked_data_type_identifiers, t)
          db_object.save
          db_object
        end

        def update_settings(flow_type_settings, db_setting_relation)
          db_settings = db_setting_relation.first(flow_type_settings.length)
          flow_type_settings.each_with_index do |setting, index|
            db_settings[index] ||= db_setting_relation.build
            db_settings[index].identifier = setting.identifier
            db_settings[index].unique = setting.unique.to_s.downcase
            db_settings[index].default_value = setting.default_value&.to_ruby
            db_settings[index].descriptions = update_translations(setting.description, db_settings[index].descriptions)
            db_settings[index].names = update_translations(setting.name, db_settings[index].names)
          end

          db_setting_relation.excluding(*db_settings).destroy_all

          db_settings
        end
      end
    end
  end
end
