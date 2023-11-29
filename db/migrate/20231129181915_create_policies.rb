# frozen_string_literal: true

class CreatePolicies < Sagittarius::Database::Migration[1.0]
  def change
    create_table :policies do |t|
      t.belongs_to :permission, null: false, foreign_key: true
      t.integer :value

      t.timestamps_with_timezone
    end
  end
end
