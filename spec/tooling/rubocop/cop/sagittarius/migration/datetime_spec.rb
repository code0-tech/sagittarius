# frozen_string_literal: true

require 'rubocop_spec_helper'
require_relative '../../../../../../tooling/rubocop/cop/sagittarius/migration/datetime'

RSpec.describe RuboCop::Cop::Sagittarius::Migration::Datetime do
  context 'when inside of migration' do
    before do
      allow(cop).to receive(:in_migration?).and_return(true)
    end

    %w[datetime timestamp].each do |method|
      it "registers an offense when the \"#{method}\" method is used" do
        expect_offense(<<~CODE)
          class Users < ActiveRecord::Migration[4.2]
            def change
              create_table :users do |t|
                t.string :username, null: false
                t.#{method} :created_at, null: true
                  #{'^' * method.length} Do not use the `#{method}` data type, use `datetime_with_timezone` instead
                t.string :password
              end
            end
          end
        CODE

        expect_correction(<<~CODE)
          class Users < ActiveRecord::Migration[4.2]
            def change
              create_table :users do |t|
                t.string :username, null: false
                t.datetime_with_timezone :created_at, null: true
                t.string :password
              end
            end
          end
        CODE
      end

      it "registers an offense when the \"#{method}\" argument is used" do
        expect_offense(<<~CODE)
          class Users < ActiveRecord::Migration[4.2]
            def change
              add_column :users, :confirmed_at, :#{method}
                                                ^#{'^' * method.length} Do not use the `#{method}` data type, use `datetime_with_timezone` instead
            end
          end
        CODE

        expect_correction(<<~CODE)
          class Users < ActiveRecord::Migration[4.2]
            def change
              add_column :users, :confirmed_at, :datetime_with_timezone
            end
          end
        CODE
      end

      it "registers an offense when the \"#{method}\" argument is used and keyword arguments are present" do
        expect_offense(<<~CODE)
          class Users < ActiveRecord::Migration[4.2]
            def change
              add_column :users, :confirmed_at, :#{method}, null: false
                                                ^#{'^' * method.length} Do not use the `#{method}` data type, use `datetime_with_timezone` instead
            end
          end
        CODE

        expect_correction(<<~CODE)
          class Users < ActiveRecord::Migration[4.2]
            def change
              add_column :users, :confirmed_at, :datetime_with_timezone, null: false
            end
          end
        CODE
      end
    end

    it 'registers no offense when datetime_with_timezone is used' do
      expect_no_offenses(<<~CODE)
        class Users < ActiveRecord::Migration[4.2]
          def change
            create_table :users do |t|
              t.string :username, null: false
              t.datetime_with_timezone :created_at, null: true
              t.string :password
            end
          end
        end
      CODE
    end
  end

  context 'when outside of migration' do
    %w[datetime timestamp].each do |method|
      it "registers no offense when using \"#{method}\"" do
        expect_no_offenses(<<~CODE)
          class Users < ActiveRecord::Migration[4.2]
              def change
                create_table :users do |t|
                  t.string :username, null: false
                  t.#{method} :created_at, null: true
                  t.string :password
                end
              end
            end
        CODE
      end
    end
  end
end
