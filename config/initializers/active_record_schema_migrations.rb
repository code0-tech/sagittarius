# frozen_string_literal: true

# Heavily inspired by the implementation of GitLab
# (https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/config/initializers/active_record_schema_versions.rb)
# which is licensed under a modified version of the MIT license which can be found at
# https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/LICENSE
#
# The code might have been modified to accommodate for the needs of this project

# rubocop:disable Layout/LineLength
Rails.application.config.to_prepare do
  # Patch to write version information as empty files under the db/schema_migrations directory
  # This is intended to reduce potential for merge conflicts in db/structure.sql
  ActiveSupport.on_load(:active_record_postgresqladapter) { prepend Sagittarius::Database::PostgresqlAdapter::DumpSchemaVersionsMixin }
  # Patch to load version information from empty files under the db/schema_migrations directory
  ActiveRecord::Tasks::PostgreSQLDatabaseTasks.prepend(Sagittarius::Database::PostgresqlDatabaseTasks::LoadSchemaVersionsMixin)
end
# rubocop:enable Layout/LineLength
