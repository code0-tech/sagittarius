# frozen_string_literal: true

module Sagittarius
  module Database
    module MigrationHelpers
      module AddColumnEnhancements
        def add_column(table_name, column_name, type, *args, **kwargs, &block)
          helper_context = self

          limit = kwargs.delete(:limit)
          unique = kwargs.delete(:unique)

          super

          return unless type == :text


          quoted_column_name = helper_context.quote_column_name(column_name)

          if limit
            name = helper_context.send(:text_limit_name, table_name, column_name)

            definition = "char_length(#{quoted_column_name}) <= #{limit}"

            add_check_constraint(table_name, definition, name: name)
          end

          if unique.is_a?(Hash)
            unique[:where] = "#{column_name} IS NOT NULL" if unique.delete(:allow_nil_duplicate)
            column_name = "LOWER(#{quoted_column_name})" if unique.delete(:case_insensitive)

            add_index table_name, column_name, unique: true, **unique
          elsif unique
            add_index table_name, column_name, unique: unique
          end
        end
      end
    end
  end
end
