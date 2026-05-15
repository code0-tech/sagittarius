# frozen_string_literal: true

module Runtimes
  module Grpc
    module DataTypes
      class UpdateService
        include Sagittarius::Database::Transactional
        include Code0::ZeroTrack::Loggable
        include Runtimes::Grpc::TranslationUpdateHelper
        include Runtimes::Grpc::DataTypeHelper

        attr_reader :current_runtime, :data_types, :runtime_module, :runtime_module_resolver,
                    :runtime_modules_to_update, :update_runtime_compatibility

        def initialize(current_runtime, data_types, runtime_module:, update_runtime_compatibility: true,
                       runtime_module_resolver: nil, runtime_modules_to_update: nil)
          @current_runtime = current_runtime
          @data_types = data_types
          @runtime_module = runtime_module
          @runtime_module_resolver = runtime_module_resolver || ->(_data_type) { runtime_module }
          @runtime_modules_to_update = runtime_modules_to_update
          @update_runtime_compatibility = update_runtime_compatibility
        end

        def execute
          transactional do |t|
            mark_existing_data_types_as_removed
            data_type_links_to_update = []

            data_types.each do |data_type|
              db_data_type = update_datatype(data_type)
              if db_data_type.persisted?
                data_type_links_to_update << [db_data_type, data_type.linked_data_type_identifiers]
                next
              end

              logger.error(message: 'Failed to update data type',
                           runtime_id: current_runtime.id,
                           data_type_identifier: data_type.identifier,
                           errors: db_data_type.errors.full_messages)

              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update data type',
                                                           error_code: :invalid_data_type, details: db_data_type.errors)
            end

            data_type_links_to_update.each do |db_data_type, linked_data_type_identifiers|
              link_data_types(db_data_type, linked_data_type_identifiers, t)
            end

            enqueue_runtime_compatibility_update

            logger.info(message: 'Updated data types for runtime', runtime_id: current_runtime.id)

            ServiceResponse.success(message: 'Updated data types', payload: data_types)
          end
        end

        protected

        def mark_existing_data_types_as_removed
          runtime_modules = runtime_modules_to_update || data_types.filter_map do |data_type|
            runtime_module_resolver.call(data_type)
          end.uniq

          # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, we don't care about validations
          DataType.where(runtime: current_runtime, runtime_module: runtime_modules)
                  .update_all(removed_at: Time.zone.now)
          # rubocop:enable Rails/SkipsModelValidations
        end

        def enqueue_runtime_compatibility_update
          return unless update_runtime_compatibility

          UpdateRuntimeCompatibilityJob.perform_later({ runtime_id: current_runtime.id })
        end

        def update_datatype(data_type)
          db_object = DataType.find_or_initialize_by(runtime: current_runtime, identifier: data_type.identifier)
          db_object.removed_at = nil
          db_object.type = data_type.type
          db_object.rules = update_rules(data_type.rules, db_object)
          db_object.names = update_translations(data_type.name, db_object.names)
          db_object.aliases = update_translations(data_type.alias, db_object.aliases)
          db_object.display_messages = update_translations(data_type.display_message, db_object.display_messages)
          db_object.generic_keys = data_type.generic_keys.to_a
          db_object.version = data_type.version
          db_object.definition_source = data_type.definition_source
          db_object.runtime_module = runtime_module_resolver.call(data_type)
          db_object.save
          db_object
        end

        # This method updates the rules of a data type in place.
        # @param rules [Array<Tucana::Shared::DefinitionDataTypeRule>] The list of rules to update.
        # @param data_type [DataType] The data type to which the rules belong.
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
      end
    end
  end
end
