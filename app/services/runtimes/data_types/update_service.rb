# frozen_string_literal: true

module Runtimes
  module DataTypes
    class UpdateService
      include Sagittarius::Database::Transactional

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
            unless update_datatype(data_type, t)
              t.rollback_and_return! ServiceResponse.error(message: 'Failed to update data type',
                                                           payload: data_type.errors)
            end
          end

          ServiceResponse.success(message: 'Updated data types', payload: data_types)
        end
      end

      protected

      def sort_data_types(data_types)
        # types without parent are already "in order" because they don't have a dependency
        sorted_types = data_types.reject { |dt| dt.parent_type_identifier.present? }
        unsorted_types = data_types - sorted_types

        unsorted_types.size.times do
          # find the next datatype that doesn't have a dependency on an unsorted type
          next_datatype = unsorted_types.find do |to_sort|
            unsorted_types.none? do |to_search|
              to_sort.parent_type_identifier == to_search.identifier
            end
          end
          sorted_types << next_datatype
          unsorted_types.delete(next_datatype)
        end

        sorted_types + unsorted_types # any unsorted types also need to be processed. They might still fail validations
      end

      def update_datatype(data_type, t)
        db_object = DataType.find_or_initialize_by(runtime: current_runtime, identifier: data_type.identifier)
        db_object.removed_at = nil
        db_object.variant = data_type.variant.to_s.downcase
        if data_type.parent_type_identifier.present?
          db_object.parent_type = find_datatype(data_type.parent_type_identifier, t)
        end
        db_object.rules = update_rules(data_type.rules, db_object)
        db_object.names = update_translations(data_type.name, db_object.names)
        db_object.save
      end

      def find_datatype(identifier, t)
        data_type = DataType.find_by(runtime: current_runtime, identifier: identifier)

        if data_type.nil?
          t.rollback_and_return! ServiceResponse.error(message: "Could not find datatype with identifier #{identifier}",
                                                       payload: :no_datatype_for_identifier)
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
