# frozen_string_literal: true

module Sagittarius
  module Database
    class Migration
      # rubocop:disable Naming/ClassAndModuleCamelCase
      class V1_0 < ::ActiveRecord::Migration[7.1]
        include Database::MigrationHelpers::AddColumnEnhancements
        include Database::MigrationHelpers::ConstraintHelpers
        include Database::MigrationHelpers::IndexHelpers
        include Database::MigrationHelpers::TableEnhancements
      end
      # rubocop:enable Naming/ClassAndModuleCamelCase

      def self.[](version)
        version = version.to_s
        name = "V#{version.tr('.', '_')}"
        raise ArgumentError, "Invalid migration version: #{version}" unless const_defined?(name, false)

        const_get(name, false)
      end
    end
  end
end
