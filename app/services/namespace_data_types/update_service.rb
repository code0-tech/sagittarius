# frozen_string_literal: true

module NamespaceDataTypes
  class UpdateService
    include Sagittarius::Database::Transactional

    attr_reader :current_runtime, :data_types

    def initialize(current_runtime, data_types)
      @current_runtime = current_runtime
      @data_types = data_types
    end

    def execute
      transactional do |t|
        data_types.each do |data_type|
          unless update_datatype(data_type)
            t.rollback_and_return! ServiceResponse.error(message: 'Failed to update data type',
                                                         payload: data_type.errors)
          end
        end

        ServiceResponse.success(message: 'Updated data types', payload: data_types)
      end
    end

    protected

    def update_datatype(data_type)
      db_object = DataType.find_or_initialize_by(namespace: current_runtime.namespace, identifier: data_type.identifier)
      db_object.variant = data_type.variant.to_s.downcase
      db_object.rules = update_rules(data_type.rules, db_object)
      db_object.translations = update_translations(data_type.name, db_object)
      db_object.save
    end

    def update_rules(rules, data_type)
      db_rules = data_type.rules.first(rules.length)
      rules.each_with_index do |rule, index|
        db_rules[index] ||= DataTypeRule.new
        db_rules[index].assign_attributes(variant: rule.variant.to_s.downcase, config: rule.config.to_h)
      end

      db_rules
    end

    def update_translations(translations, data_type)
      db_translations = data_type.translations.first(translations.length)
      translations.each_with_index do |translation, index|
        db_translations[index] ||= Translation.new
        db_translations[index].assign_attributes(code: translation.code, content: translation.content)
      end

      db_translations
    end
  end
end
