# frozen_string_literal: true

module Runtimes
  module DataTypes
    class UpdateService
      include Sagittarius::Database::Transactional
      include Code0::ZeroTrack::Loggable

      attr_reader :current_runtime, :data_types

      def initialize(current_runtime, data_types)
        @current_runtime = current_runtime
        @data_types = data_types
      end

      def execute
        transactional do |t|
          # rubocop:disable Rails/SkipsModelValidations -- when marking definitions as removed, we don't care about validations
          DataType.where(runtime: current_runtime).update_all(removed_at: Time.zone.now)
          # rubocop:enable Rails/SkipsModelValidations
          sort_data_types(data_types).each do |data_type|
            db_data_type = update_datatype(data_type, t)
            next if db_data_type.persisted?

            logger.error(message: 'Failed to update data type',
                         runtime_id: current_runtime.id,
                         data_type_identifier: data_type.identifier,
                         errors: db_data_type.errors.full_messages)

            t.rollback_and_return! ServiceResponse.error(message: 'Failed to update data type',
                                                         error_code: :invalid_data_type, details: db_data_type.errors)
          end

          UpdateRuntimeCompatibilityJob.perform_later({ runtime_id: current_runtime.id })

          logger.info(message: 'Updated data types for runtime', runtime_id: current_runtime.id)

          ServiceResponse.success(message: 'Updated data types', payload: data_types)
        end
      end

      protected

      def sort_data_types(data_types)
        # types without parent are already "in order" because they don't have a dependency
        sorted_types = data_types.reject { |dt| parent?(dt) }
        unsorted_types = data_types - sorted_types

        unsorted_types.size.times do
          # find the next datatype that doesn't have a dependency on an unsorted type
          next_datatype = unsorted_types.find do |to_sort|
            unsorted_types.none? do |to_search|
              extract_data_type_identifier_string(to_sort.rules.find do |rule|
                rule.variant == :parent_type
              end.rule_config) == to_search.identifier
            end
          end
          sorted_types << next_datatype
          unsorted_types.delete(next_datatype)
        end

        sorted_types + unsorted_types # any unsorted types also need to be processed. They might still fail validations
      end

      def extract_data_type_identifier_string(parent_type_rule_config)
        data_type = parent_type_rule_config.parent_type
        data_type.data_type_identifier || data_type.generic_type.data_type_identifier
      end

      def parent?(data_type)
        data_type.rules.any? { |rule| rule.variant == :parent_type }
      end

      def find_parent_rule(data_type)
        data_type.rules.find { |rule| rule.variant == :parent_type }
      end

      def update_datatype(data_type, t)
        db_object = DataType.find_or_initialize_by(runtime: current_runtime, identifier: data_type.identifier)
        db_object.removed_at = nil
        db_object.variant = data_type.variant.to_s.downcase
        if parent?(data_type)
          db_object.parent_type = find_data_type_identifier(find_parent_rule(data_type).rule_config, t)
        end
        db_object.rules = update_rules(data_type.rules, db_object)
        db_object.names = update_translations(data_type.name, db_object.names)
        db_object.aliases = update_translations(data_type.alias, db_object.aliases)
        db_object.display_messages = update_translations(data_type.display_message, db_object.display_messages)
        db_object.generic_keys = data_type.generic_keys.to_a
        db_object.version = data_type.version
        db_object.save
        db_object
      end

      def find_data_type_identifier(parent_type_rule_config, t)
        identifier = parent_type_rule_config.parent_type
        if identifier.data_type_identifier.present?
          return create_data_type_identifier(t, data_type_id: find_data_type(identifier.data_type_identifier, t).id)
        end

        if identifier.generic_type.present?
          data_type = find_data_type(identifier.generic_type.data_type_identifier, t)

          generic_type = GenericType.find_by(
            data_type: data_type
          )
          if generic_type.nil?
            generic_type = GenericType.create(
              runtime_id: current_runtime.id,
              data_type: data_type
            )
          end

          if generic_type.nil?
            t.rollback_and_return! ServiceResponse.error(
              message: "Could not find generic type with identifier #{identifier.generic_type.data_type_identifier}",
              error_code: :no_generic_type_for_identifier
            )
          end

          generic_type.assign_attributes(generic_mappers: update_mappers(identifier.generic_type.generic_mappers,
                                                                         t))

          return create_data_type_identifier(t, generic_type_id: generic_type.id)
        end
        return create_data_type_identifier(t, generic_key: identifier.generic_key) if identifier.generic_key.present?

        raise ArgumentError, "Invalid identifier: #{identifier.inspect}"
      end

      def create_data_type_identifier(t, **kwargs)
        data_type_identifier = DataTypeIdentifier.find_by(runtime_id: current_runtime.id, **kwargs)
        if data_type_identifier.nil?
          data_type_identifier = DataTypeIdentifier.create_or_find_by(runtime_id: current_runtime.id, **kwargs)
        end

        if data_type_identifier.nil?
          t.rollback_and_return! ServiceResponse.error(
            message: "Could not find datatype identifier with #{kwargs}",
            error_code: :no_datatype_identifier_for_generic_key
          )
        end

        data_type_identifier
      end

      def find_data_type(identifier, t)
        data_type = DataType.find_by(runtime: current_runtime, identifier: identifier)

        if data_type.nil?
          t.rollback_and_return! ServiceResponse.error(message: "Could not find datatype with identifier #{identifier}",
                                                       error_code: :no_data_type_for_identifier)
        end

        data_type
      end

      def update_rules(rules, data_type)
        db_rules = data_type.rules.first(rules.length)
        rules.each_with_index do |rule, index|
          db_rules[index] ||= DataTypeRule.new
          db_rules[index].assign_attributes(variant: rule.variant.to_s.downcase, config: rule.rule_config.to_h)
        end

        db_rules
      end

      def update_translations(translations, translation_relation)
        db_translations = translation_relation.first(translations.length)
        translations.each_with_index do |translation, index|
          db_translations[index] ||= translation_relation.build
          db_translations[index].assign_attributes(code: translation.code, content: translation.content)
        end

        db_translations
      end
    end
  end
end
