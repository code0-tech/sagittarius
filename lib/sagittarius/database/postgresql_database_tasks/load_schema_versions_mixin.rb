# frozen_string_literal: true

# Heavily inspired by the implementation of GitLab
# (https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/lib/gitlab/database/postgresql_database_tasks/load_schema_versions_mixin.rb)
# which is licensed under a modified version of the MIT license which can be found at
# https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/LICENSE
#
# The code might have been modified to accommodate for the needs of this project

module Sagittarius
  module Database
    module PostgresqlDatabaseTasks
      module LoadSchemaVersionsMixin
        extend ActiveSupport::Concern

        def structure_load(...)
          super

          Sagittarius::Database::SchemaMigrations.load_all(connection)
        end
      end
    end
  end
end
