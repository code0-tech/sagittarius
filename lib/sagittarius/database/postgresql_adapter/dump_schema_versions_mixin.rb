# frozen_string_literal: true

# Heavily inspired by the implementation of GitLab
# (https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/lib/gitlab/database/postgresql_adapter/dump_schema_versions_mixin.rb)
# which is licensed under a modified version of the MIT license which can be found at
# https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/LICENSE
#
# The code might have been modified to accommodate for the needs of this project

module Sagittarius
  module Database
    module PostgresqlAdapter
      module DumpSchemaVersionsMixin
        extend ActiveSupport::Concern

        def dump_schema_information
          # rubocop:disable Rails/SkipsModelValidations -- not an active record object
          Sagittarius::Database::SchemaMigrations.touch_all(self) unless Rails.env.production?
          # rubocop:enable Rails/SkipsModelValidations
          nil
        end
      end
    end
  end
end
