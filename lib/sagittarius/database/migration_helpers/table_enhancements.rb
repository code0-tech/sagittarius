# frozen_string_literal: true

module Sagittarius
  module Database
    module MigrationHelpers
      module TableEnhancements
        def create_table(table_name, *args, **kwargs, &block)
          helper_context = self

          super do |t|
            enhance(t, table_name, helper_context, &block)
          end
        end

        def change_table(table_name, *args, **kwargs, &block)
          helper_context = self

          super do |t|
            enhance(t, table_name, helper_context, &block)
          end
        end

        private

        # rubocop:disable Metrics/CyclomaticComplexity
        # rubocop:disable Metrics/PerceivedComplexity
        def enhance(t, table_name, helper_context, &block)
          t.define_singleton_method(:text) do |column_name, **inner_kwargs|
            limit = inner_kwargs.delete(:limit)
            unique = inner_kwargs.delete(:unique)

            super(column_name, **inner_kwargs)

            quoted_column_name = helper_context.quote_column_name(column_name)

            if limit
              name = helper_context.send(:text_limit_name, table_name, column_name)

              definition = "char_length(#{quoted_column_name}) <= #{limit}"

              t.check_constraint(definition, name: name)
            end

            if unique.is_a?(Hash)
              index_definition = column_name
              unique[:where] = "#{column_name} IS NOT NULL" if unique.delete(:allow_nil_duplicate)
              index_definition = "LOWER(#{quoted_column_name})" if unique.delete(:case_insensitive)

              t.index index_definition, unique: true, **unique
            elsif unique
              t.index column_name, unique: unique
            end
          end

          return if block.nil?

          t.instance_eval do |obj|
            if block.arity == 1
              block.call(obj)
            elsif block.arity == 2
              block.call(obj, helper_context)
            else
              raise ArgumentError, "Unsupported arity of #{block.arity}"
            end
          end
        end
        # rubocop:enable Metrics/PerceivedComplexity
        # rubocop:enable Metrics/CyclomaticComplexity
      end
    end
  end
end
