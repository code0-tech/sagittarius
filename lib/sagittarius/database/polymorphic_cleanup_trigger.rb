# frozen_string_literal: true

module Sagittarius
  module Database
    module PolymorphicCleanupTrigger
      def create_polymorphic_cleanup_trigger(table, parent_table, parent_column, parent_class)
        function_name = "delete_#{parent_table}_#{table}"
        trigger_name = "trigger_#{function_name}"

        execute <<~SQL.squish
          CREATE OR REPLACE FUNCTION #{quote_column_name(function_name)}()
          RETURNS TRIGGER AS $$
          BEGIN
            DELETE FROM #{quote_table_name(table)}
            WHERE #{quote_column_name("#{parent_column}_type")} = #{quote(parent_class)}
              AND #{quote_column_name("#{parent_column}_id")} IN (SELECT id FROM old_rows);
            RETURN NULL;
          END;
          $$ LANGUAGE plpgsql;

          CREATE TRIGGER #{quote_column_name(trigger_name)}
          AFTER DELETE ON #{quote_table_name(parent_table)}
          REFERENCING OLD TABLE AS old_rows
          FOR EACH STATEMENT
          EXECUTE FUNCTION #{quote_column_name(function_name)}();
        SQL
      end

      def drop_polymorphic_cleanup_trigger(table, parent_table)
        function_name = "delete_#{parent_table}_#{table}"
        trigger_name = "trigger_#{function_name}"

        execute <<~SQL.squish
          DROP TRIGGER #{quote_column_name(trigger_name)} ON #{quote_table_name(parent_table)};
          DROP FUNCTION #{quote_column_name(function_name)}();
        SQL
      end

      private

      def quote(value)
        connection.quote(value)
      end

      def quote_column_name(name)
        connection.quote_column_name(name)
      end

      def quote_table_name(name)
        connection.quote_table_name(name)
      end
    end
  end
end
