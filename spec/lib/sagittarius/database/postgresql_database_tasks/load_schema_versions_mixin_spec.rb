# frozen_string_literal: true

# Heavily inspired by the implementation of GitLab
# (https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/spec/lib/gitlab/database/postgresql_database_tasks/load_schema_versions_mixin_spec.rb)
# which is licensed under a modified version of the MIT license which can be found at
# https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/LICENSE
#
# The code might have been modified to accommodate for the needs of this project

require 'rails_helper'

RSpec.describe Sagittarius::Database::PostgresqlDatabaseTasks::LoadSchemaVersionsMixin do
  let(:instance_class) do
    klass = Class.new do
      def structure_load
        original_structure_load
      end

      def original_structure_load; end
      def connection; end
    end

    klass.prepend(described_class)

    klass
  end

  let(:instance) { instance_class.new }

  it 'calls SchemaMigrations load_all' do
    connection = double('connection') # rubocop:disable RSpec/VerifiedDoubles -- we don't need an actual connection here
    allow(instance).to receive(:connection).and_return(connection)
    allow(instance).to receive(:original_structure_load)
    allow(Sagittarius::Database::SchemaMigrations).to receive(:load_all)

    instance.structure_load

    expect(instance).to have_received(:original_structure_load).ordered
    expect(Sagittarius::Database::SchemaMigrations).to have_received(:load_all).with(connection).ordered
  end
end
