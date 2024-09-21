# frozen_string_literal: true

# Heavily inspired by the implementation of GitLab
# (https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/spec/lib/gitlab/database/schema_migrations/context_spec.rb)
# which is licensed under a modified version of the MIT license which can be found at
# https://gitlab.com/gitlab-org/gitlab/-/blob/7983d2a2203aff265fae479d7c1b7066858d1265/LICENSE
#
# The code might have been modified to accommodate for the needs of this project

require 'rails_helper'

RSpec.describe Sagittarius::Database::SchemaMigrations::Context do
  let(:connection_class) { ActiveRecord::Base }
  let(:connection) { connection_class.connection }

  let(:context) { described_class.new(connection) }

  it '#schema_directory returns db/schema_migrations' do
    expect(context.schema_directory).to eq(Rails.root.join(described_class.default_schema_migrations_path).to_s)
  end

  describe '#versions_to_create' do
    before do
      # rubocop:disable RSpec/MessageChain -- we are mocking into active records structure
      allow(connection.pool).to receive_message_chain(:schema_migration, :versions).and_return(migrated_versions)

      migrations_struct = Struct.new(:version)
      migrations = file_versions.map { |version| migrations_struct.new(version) }
      allow(connection.pool).to receive_message_chain(:migration_context, :migrations).and_return(migrations)
      # rubocop:enable RSpec/MessageChain
    end

    # rubocop:disable RSpec/IndexedLet -- these indexes do make sense
    let(:version1) { '20200123' }
    let(:version2) { '20200410' }
    let(:version3) { '20200602' }
    let(:version4) { '20200809' }
    # rubocop:enable RSpec/IndexedLet

    let(:file_versions) { [version1, version2, version3, version4] }
    let(:migrated_versions) { file_versions }

    context 'when migrated versions is the same as migration file versions' do
      it 'returns migrated versions' do
        expect(context.versions_to_create).to eq(migrated_versions)
      end
    end

    context 'when migrated versions is subset of migration file versions' do
      let(:migrated_versions) { [version1, version2] }

      it 'returns migrated versions' do
        expect(context.versions_to_create).to eq(migrated_versions)
      end
    end

    context 'when migrated versions is superset of migration file versions' do
      let(:migrated_versions) { file_versions + ['20210809'] }

      it 'returns file versions' do
        expect(context.versions_to_create).to eq(file_versions)
      end
    end

    context 'when migrated versions has slightly different versions to migration file versions' do
      let(:migrated_versions) { [version1, version2, version3, version4, '20210101'] }
      let(:file_versions) { [version1, version2, version3, version4, '20210102'] }

      it 'returns the common set' do
        expect(context.versions_to_create).to eq([version1, version2, version3, version4])
      end
    end
  end
end
