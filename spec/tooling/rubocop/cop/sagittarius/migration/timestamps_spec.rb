# frozen_string_literal: true

require 'rubocop_spec_helper'
require_relative '../../../../../../tooling/rubocop/cop/sagittarius/migration/timestamps'

RSpec.describe RuboCop::Cop::Sagittarius::Migration::Timestamps do
  context 'when inside of migration' do
    before do
      allow(cop).to receive(:in_migration?).and_return(true)
    end

    it 'registers an offense when the "timestamps" method is used' do
      expect_offense(<<~CODE)
        class Users < ActiveRecord::Migration[4.2]
          def change
            create_table :users do |t|
              t.string :username, null: false
              t.timestamps null: true
                ^^^^^^^^^^ Do not use `timestamps`, use `timestamps_with_timezone` instead
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
              t.timestamps_with_timezone null: true
              t.string :password
            end
          end
        end
      CODE
    end

    it 'registers no offense when timestamps_with_timezone is used' do
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

  context 'when outside of migration' do
    it 'registers no offense' do
      expect_no_offenses(<<~CODE)
        class Users < ActiveRecord::Migration[4.2]
          def change
            create_table :users do |t|
              t.string :username, null: false
              t.timestamps null: true
              t.string :password
            end
          end
        end
      CODE
    end
  end
end
