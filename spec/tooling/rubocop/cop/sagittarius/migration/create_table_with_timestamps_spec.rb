# frozen_string_literal: true

require 'rubocop_spec_helper'
require_relative '../../../../../../tooling/rubocop/cop/sagittarius/migration/create_table_with_timestamps'

RSpec.describe RuboCop::Cop::Sagittarius::Migration::CreateTableWithTimestamps do
  context 'when inside of migration' do
    before do
      allow(cop).to receive(:in_migration?).and_return(true)
    end

    it 'registers an offense when the a table without timestamps is created' do
      expect_offense(<<~CODE)
        class CreateUsers < ActiveRecord::Migration[7.0]
          def change
            create_table :users do |t|
            ^^^^^^^^^^^^^^^^^^^^^^^^^^ Add timestamps when creating a new table.
              t.string :username
            end
          end
        end
      CODE
    end

    context "when created_at and updated_at are not 'datetime_with_timezone'" do
      it "registers an offense when 'created_at' has the wrong type" do
        expect_offense(<<~CODE)
          class Users < ActiveRecord::Migration[7.0]
            def change
              create_table :users do |t|
              ^^^^^^^^^^^^^^^^^^^^^^^^^^ Add timestamps when creating a new table.
                t.string :username, null: false
                t.string :created_at, null: true
                t.datetime_with_timezone :updated_at, null: true
                t.string :password
              end
            end
          end
        CODE
      end

      it "registers an offense when 'updated_at' has the wrong type" do
        expect_offense(<<~CODE)
          class Users < ActiveRecord::Migration[7.0]
            def change
              create_table :users do |t|
              ^^^^^^^^^^^^^^^^^^^^^^^^^^ Add timestamps when creating a new table.
                t.string :username, null: false
                t.datetime_with_timezone :created_at, null: true
                t.string :updated_at, null: true
                t.string :password
              end
            end
          end
        CODE
      end

      it "registers an offense when 'created_at' and 'updated_at' have the wrong type" do
        expect_offense(<<~CODE)
          class Users < ActiveRecord::Migration[7.0]
            def change
              create_table :users do |t|
              ^^^^^^^^^^^^^^^^^^^^^^^^^^ Add timestamps when creating a new table.
                t.string :username, null: false
                t.string :created_at, null: true
                t.string :updated_at, null: true
                t.string :password
              end
            end
          end
        CODE
      end
    end

    it "registers no offense when both 'created_at' and 'updated_at' are defined manually" do
      expect_no_offenses(<<~CODE)
        class Users < ActiveRecord::Migration[7.0]
          def change
            create_table :users do |t|
              t.string :username, null: false
              t.datetime_with_timezone :created_at, null: true
              t.datetime_with_timezone :updated_at, null: true
              t.string :password
            end
          end
        end
      CODE
    end

    context 'when multi-arg block from migration helper is used' do
      it 'registers no offense when timestamps are present' do
        expect_no_offenses(<<~CODE)
          class User < Sagittarius::Database::Migration[1.0]
            def change
              create_table :users do |t, helper|
                t.string :username, null: false

                t.timestamps_with_timezone
              end
            end
          end
        CODE
      end

      it 'registers an offense when timestamps are not present' do
        expect_offense(<<~CODE)
          class CreateUsers < ActiveRecord::Migration[7.0]
            def change
              create_table :users do |t, helper|
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Add timestamps when creating a new table.
                t.string :username
              end
            end
          end
        CODE
      end
    end
  end

  context 'when outside of migration' do
    it 'registers no offense' do
      expect_no_offenses(<<~CODE)
        class CreateUsers < ActiveRecord::Migration[7.0]
          def change
            create_table :users do |t|
              t.string :username
            end
          end
        end
      CODE
    end
  end
end
