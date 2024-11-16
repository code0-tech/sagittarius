# frozen_string_literal: true

# Heavily inspired by the implementation of GitLab
# (https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/spec/lib/gitlab/database/schema_migrations/migrations_spec.rb)
# which is licensed under a modified version of the MIT license which can be found at
# https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/LICENSE
#
# The code might have been modified to accommodate for the needs of this project

require 'rails_helper'

RSpec.describe Sagittarius::Database::SchemaMigrations::Migrations do
  let(:connection) { ApplicationRecord.connection }
  let(:context) { Sagittarius::Database::SchemaMigrations::Context.new(connection) }

  let(:migrations) { described_class.new(context) }

  describe '#touch_all' do
    # rubocop:disable RSpec/IndexedLet -- these indexes do make sense
    let(:version1) { '20200123' }
    let(:version2) { '20200410' }
    let(:version3) { '20200602' }
    let(:version4) { '20200809' }
    # rubocop:enable RSpec/IndexedLet

    let(:relative_schema_directory) { 'db/schema_migrations' }

    it 'creates a file containing a checksum for each version with a matching migration' do
      Dir.mktmpdir do |tmpdir|
        schema_directory = Pathname.new(tmpdir).join(relative_schema_directory)
        FileUtils.mkdir_p(schema_directory)

        old_version_filepath = schema_directory.join('20200101')
        FileUtils.touch(old_version_filepath)

        expect(File.exist?(old_version_filepath)).to be(true)

        allow(context).to receive_messages(schema_directory: schema_directory, versions_to_create: [version1, version2])

        migrations.touch_all # rubocop:disable Rails/SkipsModelValidations -- not an active record object

        expect(File.exist?(old_version_filepath)).to be(false)

        [version1, version2].each do |version|
          version_filepath = schema_directory.join(version)
          expect(File.exist?(version_filepath)).to be(true)

          hashed_value = Digest::SHA256.hexdigest(version)
          expect(File.read(version_filepath)).to eq(hashed_value)
        end

        [version3, version4].each do |version|
          version_filepath = schema_directory.join(version)
          expect(File.exist?(version_filepath)).to be(false)
        end
      end
    end
  end

  describe '#load_all' do
    before do
      allow(migrations).to receive(:version_filenames).and_return(filenames)
    end

    context 'when there are no version files' do
      let(:filenames) { [] }

      it 'does nothing' do
        allow(connection).to receive(:quote_string)
        allow(connection).to receive(:execute)

        migrations.load_all

        expect(connection).not_to have_received(:quote_string)
        expect(connection).not_to have_received(:execute)
      end
    end

    context 'when there are version files' do
      let(:filenames) { %w[123 456 789] }

      it 'inserts the missing versions into schema_migrations' do
        allow(connection).to receive(:quote_string).with('schema_migrations').and_return('schema_migrations')
        filenames.each do |filename|
          allow(connection).to receive(:quote_string).with(filename).and_return(filename)
        end
        allow(connection).to receive(:execute)

        migrations.load_all

        filenames.each do |filename|
          expect(connection).to have_received(:quote_string).with(filename)
        end
        expect(connection).to have_received(:execute).with(<<~SQL.squish)
          INSERT INTO schema_migrations (version)
          VALUES ('123'),('456'),('789')
          ON CONFLICT DO NOTHING
        SQL
      end

      it 'does nothing if schema_migrations table does not exist' do
        allow(connection).to receive(:execute)

        schema_migration = connection.pool.schema_migration
        allow(connection.pool).to receive(:schema_migration).and_return(schema_migration)
        allow(schema_migration).to receive(:table_exists?).and_return(false)

        migrations.load_all

        expect(connection).not_to have_received(:execute)
      end
    end
  end
end
