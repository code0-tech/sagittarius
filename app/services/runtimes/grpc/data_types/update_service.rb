# frozen_string_literal: true

module Runtimes
  module Grpc
    module DataTypes
      class UpdateService
        include Sagittarius::Database::Transactional
        include Code0::ZeroTrack::Loggable
        include Runtimes::Grpc::TranslationUpdateHelper
        include Runtimes::Grpc::DataTypeHelper

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
                extract_data_type_identifier_strings(to_sort.rules.find do |rule|
                  rule.variant == :parent_type
                end.rule_config).include?(to_search.identifier)
              end
            end
            sorted_types << next_datatype
            unsorted_types.delete(next_datatype)
          end

          # any unsorted types also need to be processed. They might still fail validations
          sorted_types + unsorted_types
        end

        def extract_data_type_identifier_strings(parent_type_rule_config)
          types = []
          data_type = parent_type_rule_config.parent_type

          if data_type.generic_type.nil?
            types << data_type.data_type_identifier
          else
            types << data_type.generic_type.data_type_identifier
            data_type.generic_type.generic_mappers.to_a.each do |mapper|
              mapper.source.each do |source_identifier|
                types += extract_data_type_identifier_strings(
                  Tucana::Shared::DefinitionDataTypeParentTypeRuleConfig.new(parent_type: source_identifier)
                )
              end
            end
          end

          types
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
            db_object.parent_type = find_data_type_identifier(find_parent_rule(data_type).rule_config.parent_type, t)
          end
          db_object.rules = update_rules(data_type.rules, db_object, t)
          db_object.names = update_translations(data_type.name, db_object.names)
          db_object.aliases = update_translations(data_type.alias, db_object.aliases)
          db_object.display_messages = update_translations(data_type.display_message, db_object.display_messages)
          db_object.generic_keys = data_type.generic_keys.to_a
          db_object.version = data_type.version
          db_object.save
          db_object
        end

        # This method updates the rules of a data type in place.
        # It ensures that existing rules are updated and new rules are created as needed.
        # @param rules [Array<Tucana::Shared::DefinitionDataTypeRule>] The list of rules to update.
        # @param data_type [DataType] The data type to which the rules belong.
        def update_rules(rules, data_type, t)
          db_rules = data_type.rules.first(rules.length)
          rules.each_with_index do |rule, index|
            db_rules[index] ||= DataTypeRule.new
            db_rules[index].assign_attributes(variant: rule.variant.to_s.downcase, config: extend_rule_config(rule, t))
          end

          db_rules
        end

        def extend_rule_config(rule, t)
          case rule.variant
          when :parent_type
            {}
          when :contains_key
            {
              key: rule.rule_config.key,
              data_type_identifier: rule.rule_config.data_type_identifier,
              data_type_identifier_id: find_data_type_identifier(rule.rule_config.data_type_identifier, t).id,
            }
          when :contains_type, :return_type
            {
              data_type_identifier: rule.rule_config.data_type_identifier,
              data_type_identifier_id: find_data_type_identifier(rule.rule_config.data_type_identifier, t).id,
            }
          when :input_types
            {
              input_types: rule.rule_config.input_types.map do |input_type|
                {
                  input_identifier: input_type.input_identifier,
                  data_type_identifier: input_type.data_type_identifier,
                  data_type_identifier_id: find_data_type_identifier(input_type.data_type_identifier, t).id,
                }
              end,
            }
          else
            rule.rule_config.to_h
          end
        end
      end
    end
  end
end
