# frozen_string_literal: true

require 'rubocop_spec_helper'
require_relative '../../../../../../tooling/rubocop/cop/sagittarius/migration/versioned_class'

require 'active_record'
Dir[File.join(__dir__, '..', '..', '..', '..', '..', '..',
              'lib', 'sagittarius', 'database', 'migration_helpers', '*.rb')].each { |file| require file }

require_relative '../../../../../../lib/sagittarius/database/migration'

RSpec.describe RuboCop::Cop::Sagittarius::Migration::VersionedClass do
  describe 'does not reference invalid migration versions' do
    described_class::ALLOWED_MIGRATION_VERSIONS.each do |range, version|
      it "in range #{range}" do
        expect { Sagittarius::Database::Migration[version] }.not_to raise_error
      end
    end
  end

  it 'has one allowed version without end in range' do
    versions_without_end_range = described_class::ALLOWED_MIGRATION_VERSIONS.select { |range, _| range.end.nil? }

    expect(versions_without_end_range.count).to eq(1)
  end

  context 'when inside of migration' do
    before do
      allow(cop).to receive_messages(in_migration?: true, basename: '20231129173717_create_users')
    end

    it 'registers an offense when the "ActiveRecord::Migration" class is used' do
      expect_offense(<<~CODE)
        class Users < ActiveRecord::Migration[4.2]
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Don't use `ActiveRecord::Migration`. Use `Sagittarius::Database::Migration` instead.
          def change
            create_table :users do |t|
              t.string :username, null: false
              t.timestamps_with_timezone null: true
              t.string :password
            end
          end
        end
      CODE

      expect_correction(<<~CODE)
        class Users < Sagittarius::Database::Migration[1.0]
          def change
            create_table :users do |t|
              t.string :username, null: false
              t.timestamps_with_timezone null: true
              t.string :password
            end
          end
        end
      CODE
    end

    it 'registers an offense when the wrong version of "Sagittarius::Database::Migration" is used' do
      expect_offense(<<~CODE)
        class Users < Sagittarius::Database::Migration[1.1]
                                                       ^^^ Don't use version `1.1` of `Sagittarius::Database::Migration`. Use version `1.0` instead.
          def change
            create_table :users do |t|
              t.string :username, null: false
              t.timestamps_with_timezone null: true
              t.string :password
            end
          end
        end
      CODE

      expect_correction(<<~CODE)
        class Users < Sagittarius::Database::Migration[1.0]
          def change
            create_table :users do |t|
              t.string :username, null: false
              t.timestamps_with_timezone null: true
              t.string :password
            end
          end
        end
      CODE
    end

    it 'registers no offense when correct version is used' do
      expect_no_offenses(<<~CODE)
        class Users < Sagittarius::Database::Migration[1.0]
          def change
            create_table :users do |t|
              t.string :username, null: false
              t.timestamps_with_timezone null: true
              t.string :password
            end
          end
        end
      CODE
    end
  end

  context 'when outside of migration' do
    it 'registers no offense' do
      expect_no_offenses(<<~CODE)
        class Users < ActiveRecord::Migration[4.2]
          def change
            create_table :users do |t|
              t.string :username, null: false
              t.timestamps_with_timezone null: true
              t.string :password
            end
          end
        end
      CODE
    end
  end
end
